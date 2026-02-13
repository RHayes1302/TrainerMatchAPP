//
//  VideoMessageCameraView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  VideoMessageCameraView.swift
//  TrainerMatch
//
//  Camera view for recording video messages to clients
//

import SwiftUI

struct VideoMessageCameraView: View {
    @ObservedObject var viewModel: VideoMessageViewModel
    let clientName: String
    let clientId: String
    @Environment(\.dismiss) var dismiss
    
    @State private var showingSaveSheet = false
    @State private var tempTitle = ""
    @State private var tempMessage = ""
    @State private var selectedMessageType: VideoMessage.MessageType = .general
    @State private var recordingDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var countdown: Int = 3
    @State private var isCountingDown = false
    
    var body: some View {
        ZStack {
            // Camera preview
            if viewModel.cameraService.isSessionRunning {
                CameraPreviewView(session: viewModel.cameraService.getCaptureSession())
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            // Countdown overlay with TrainerMatch branding
            if isCountingDown {
                ZStack {
                    Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        TrainerMatchLogo(size: .large)
                            .scaleEffect(2.0)
                            .opacity(0.5)
                        
                        Text("\(countdown)")
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(.tmGold)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                }
            }
            
            // UI Overlay
            VStack {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Client name indicator
                    if !viewModel.cameraService.isRecording && !isCountingDown {
                        VStack(spacing: 2) {
                            Text("Message to:")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Text(clientName)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.tmGold)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(20)
                    }
                    
                    // Recording timer
                    if viewModel.cameraService.isRecording {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                            Text(formatDuration(recordingDuration))
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    // Flip camera button
                    Button(action: {
                        viewModel.cameraService.flipCamera()
                    }) {
                        Image(systemName: "camera.rotate")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                Spacer()
                
                // Camera position indicator at bottom
                if !viewModel.cameraService.isRecording && !isCountingDown {
                    Text(viewModel.cameraService.currentCameraPosition == .front ? "FRONT CAMERA" : "BACK CAMERA")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.tmGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                }
                
                // Record button
                Button(action: {
                    if !isCountingDown {
                        if viewModel.cameraService.isRecording {
                            stopRecording()
                        } else {
                            startCountdown()
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(Color.tmGold, lineWidth: 5)
                            .frame(width: 80, height: 80)
                        
                        if viewModel.cameraService.isRecording {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red)
                                .frame(width: 40, height: 40)
                        } else {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 70, height: 70)
                        }
                    }
                }
                .disabled(isCountingDown)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            viewModel.cameraService.startSession()
            viewModel.currentClientId = clientId
            tempTitle = "Message for \(clientName)"
        }
        .onDisappear {
            viewModel.cameraService.stopSession()
            if viewModel.cameraService.isRecording {
                stopRecording()
            }
        }
        .onChange(of: viewModel.temporaryVideoURL) { oldValue, newValue in
            if newValue != nil && !showingSaveSheet {
                showingSaveSheet = true
            }
        }
        .sheet(isPresented: $showingSaveSheet) {
            SaveVideoMessageView(
                title: $tempTitle,
                message: $tempMessage,
                messageType: $selectedMessageType,
                clientName: clientName,
                viewModel: viewModel,
                onSend: {
                    viewModel.sendMessage(
                        to: clientId,
                        title: tempTitle,
                        message: tempMessage,
                        messageType: selectedMessageType
                    )
                    dismiss()
                },
                onCancel: {
                    viewModel.cancelRecording()
                    dismiss()
                }
            )
        }
    }
    
    private func startCountdown() {
        isCountingDown = true
        countdown = 3
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                isCountingDown = false
                startRecording()
            }
        }
    }
    
    private func startRecording() {
        recordingDuration = 0
        viewModel.startRecording()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingDuration += 0.1
        }
    }
    
    private func stopRecording() {
        viewModel.stopRecording()
        timer?.invalidate()
        timer = nil
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
