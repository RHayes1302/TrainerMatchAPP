//
//  CameraService.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  CameraService.swift
//  VideoCameraDemo
//
//  Created by Ramone Hayes on 2/5/26.
//

import Foundation
import AVFoundation
import UIKit

class CameraService: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var isSessionRunning = false
    @Published var isRecording = false
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    @Published var currentCameraPosition: AVCaptureDevice.Position = .back
    
    var temporaryVideoURL: URL?
    var recordingCompletion: ((URL) -> Void)?
    private var shouldRestartRecording = false
    private var restartCompletion: ((URL) -> Void)?

    private var captureSession = AVCaptureSession()
    private var movieOutput = AVCaptureMovieFileOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?

    func setupCamera() {
        checkAuthorization()
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(videoInput)
        self.videoDeviceInput = videoInput
        
        if let audioDevice = AVCaptureDevice.default(for: .audio),
           let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
           captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            authorizationStatus = .authorized
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.authorizationStatus = granted ? .authorized : .denied
                }
            }
        case .denied, .restricted:
            authorizationStatus = .denied
        @unknown default:
            authorizationStatus = .denied
        }
    }

    func getCaptureSession() -> AVCaptureSession { captureSession }

    func startSession() {
        guard authorizationStatus == .authorized else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, !self.captureSession.isRunning else { return }
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.isSessionRunning = true
            }
        }
    }

    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self, self.captureSession.isRunning else { return }
            self.captureSession.stopRunning()
            DispatchQueue.main.async {
                self.isSessionRunning = false
            }
        }
    }

    func startRecording(completion: @escaping (URL) -> Void) {
        print("🎥 CameraService: startRecording() called")
        print("   isRecording before: \(isRecording)")
        print("   recordingCompletion before: \(recordingCompletion != nil ? "EXISTS" : "NIL")")
        
        guard !isRecording else {
            print("❌ Already recording! Aborting.")
            return
        }
        
        self.recordingCompletion = completion
        print("   ✅ recordingCompletion SET")
        isRecording = true

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp_\(UUID().uuidString).mov")
        
        print("   Setting up new recording:")
        print("     - tempURL: \(tempURL)")
        print("     - isRecording set to: \(isRecording)")
        
        movieOutput.startRecording(to: tempURL, recordingDelegate: self)
        temporaryVideoURL = tempURL
        print("🔴 Started recording to: \(tempURL)")
    }

    func stopRecording() {
        print("⏹️ CameraService: stopRecording() called")
        print("   isRecording: \(isRecording)")
        print("   recordingCompletion: \(recordingCompletion != nil ? "EXISTS" : "NIL")")
        
        guard isRecording else {
            print("❌ Not recording! Nothing to stop.")
            return
        }
        
        movieOutput.stopRecording()
        print("   stopRecording() command sent to movieOutput")
    }
    
    func flipCamera() {
        print("🔄 Flipping camera...")
        
        // If recording, we need to stop, flip, then restart
        let wasRecording = isRecording
        if wasRecording {
            print("⏸️ Recording active - will stop, flip, and restart")
            shouldRestartRecording = true
            restartCompletion = recordingCompletion
            
            // IMPORTANT: Set isRecording to false BEFORE calling stopRecording
            // so the fileOutput delegate will properly handle the stop
            print("   Setting isRecording to false temporarily for flip")
            isRecording = false
            
            movieOutput.stopRecording()
            print("   Stop recording command sent")
        }
        
        // Wait for recording to stop, then flip
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performFlip()
            
            // Restart recording after flip
            if wasRecording && self?.shouldRestartRecording == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("   Attempting to restart recording after flip...")
                    if let completion = self?.restartCompletion {
                        self?.shouldRestartRecording = false
                        self?.startRecording(completion: completion)
                        print("▶️ Recording restarted after flip")
                    } else {
                        print("❌ No restart completion handler!")
                        self?.shouldRestartRecording = false
                    }
                }
            }
        }
    }
    
    private func performFlip() {
        captureSession.beginConfiguration()
        
        if let currentInput = videoDeviceInput {
            captureSession.removeInput(currentInput)
        }
        
        let newPosition: AVCaptureDevice.Position = currentCameraPosition == .back ? .front : .back
        
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: newCamera),
              captureSession.canAddInput(newInput) else {
            if let currentInput = videoDeviceInput, captureSession.canAddInput(currentInput) {
                captureSession.addInput(currentInput)
            }
            captureSession.commitConfiguration()
            print("❌ Failed to flip camera")
            return
        }
        
        captureSession.addInput(newInput)
        videoDeviceInput = newInput
        currentCameraPosition = newPosition
        
        captureSession.commitConfiguration()
        print("✅ Flipped to \(newPosition == .front ? "front" : "back") camera")
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("📹 fileOutput delegate called")
        print("   outputFileURL: \(outputFileURL)")
        print("   shouldRestartRecording: \(shouldRestartRecording)")
        print("   error: \(String(describing: error))")
        print("   recordingCompletion exists: \(recordingCompletion != nil)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                print("   ❌ self is nil!")
                return
            }
            
            print("   In main queue - shouldRestartRecording: \(self.shouldRestartRecording)")
            
            // If we're restarting (flip camera), don't process this as a final recording
            if self.shouldRestartRecording {
                print("   ⏭️ Skipping completion - will restart recording")
                return
            }
            
            // Normal recording finish
            print("   Setting isRecording to false")
            self.isRecording = false
            
            if let error = error {
                print("❌ Recording error: \(error)")
                if let completion = self.recordingCompletion {
                    completion(outputFileURL)
                    print("   ✅ Completion called despite error")
                } else {
                    print("   ❌ No completion handler!")
                }
                self.recordingCompletion = nil
                return
            }
            
            print("✅ Recording finished successfully: \(outputFileURL)")
            print("📁 File exists: \(FileManager.default.fileExists(atPath: outputFileURL.path))")
            
            if let completion = self.recordingCompletion {
                print("   Calling completion handler...")
                completion(outputFileURL)
                print("   ✅ Completion handler called")
                self.recordingCompletion = nil
                print("   Completion handler cleared")
            } else {
                print("   ❌❌❌ NO COMPLETION HANDLER EXISTS!")
            }
        }
    }
}
