//
//  VideoMessageViewModel.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  VideoMessageViewModel.swift
//  TrainerMatch
//
//  ViewModel for managing video messages between trainers and clients
//

import Foundation
import AVFoundation
import SwiftUI

class VideoMessageViewModel: ObservableObject {
    @Published var videoMessages: [VideoMessage] = []
    @Published var cameraService = CameraService()
    @Published var selectedMessage: VideoMessage?
    @Published var showingCameraSheet = false
    @Published var showingDetailSheet = false
    @Published var temporaryVideoURL: URL?
    
    // Current context for sending messages
    @Published var currentClientId: String?
    @Published var currentTrainerId: String = "trainer1" // In real app, from auth
    
    private let fileManager = FileManager.default
    
    init() {
        loadMessages()
        cameraService.setupCamera()
        // Start session early so it's ready when camera opens
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cameraService.startSession()
        }
    }
    
    // MARK: - Recording Functions
    
    func startRecording() {
        print("🎬 VideoMessageViewModel: startRecording() called")
        
        cameraService.startRecording { [weak self] url in
            print("📝 Recording completion handler called with URL: \(url)")
            DispatchQueue.main.async {
                self?.temporaryVideoURL = url
                print("✅ VideoMessageViewModel: temporaryVideoURL set to: \(url)")
            }
        }
    }
    
    func stopRecording() {
        print("⏹️ VideoMessageViewModel: stopRecording() called")
        cameraService.stopRecording()
    }
    
    func cancelRecording() {
        print("🗑️ Canceling recording...")
        if let tempURL = temporaryVideoURL {
            print("   Deleting file: \(tempURL)")
            try? fileManager.removeItem(at: tempURL)
            temporaryVideoURL = nil
        }
        print("   temporaryVideoURL cleared")
    }
    
    // MARK: - Message Management
    
    func sendMessage(to clientId: String,
                    title: String,
                    message: String,
                    messageType: VideoMessage.MessageType) {
        print("💾 ========== SEND VIDEO MESSAGE START ==========")
        print("   Title: '\(title)'")
        print("   Message: '\(message)'")
        print("   Client ID: \(clientId)")
        print("   Message Type: \(messageType.rawValue)")
        print("   temporaryVideoURL: \(String(describing: temporaryVideoURL))")
        
        guard let tempURL = temporaryVideoURL else {
            print("❌ FAILED: No temporary video URL!")
            print("💾 ========== SEND VIDEO MESSAGE END (FAILED) ==========")
            return
        }
        
        let fileExists = fileManager.fileExists(atPath: tempURL.path)
        print("   File exists at temp location: \(fileExists)")
        
        let fileName = "video_msg_\(UUID().uuidString).mov"
        let destURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        
        print("   Moving from: \(tempURL.path)")
        print("   Moving to: \(destURL.path)")
        
        do {
            try fileManager.moveItem(at: tempURL, to: destURL)
            print("✅ File moved successfully")
            
            let asset = AVAsset(url: destURL)
            let duration = asset.duration.seconds
            print("   Duration: \(duration)s")
            
            let newMessage = VideoMessage(
                trainerId: currentTrainerId,
                clientId: clientId,
                title: title.isEmpty ? "Video Message" : title,
                message: message,
                videoFileName: fileName,
                duration: duration,
                messageType: messageType
            )
            
            print("   Creating message with:")
            print("     - title: \(newMessage.title)")
            print("     - fileName: \(newMessage.videoFileName)")
            print("     - duration: \(newMessage.duration)")
            
            videoMessages.insert(newMessage, at: 0)
            print("   Message added to array. Total messages: \(videoMessages.count)")
            
            // Clear the temporary URL
            temporaryVideoURL = nil
            
            saveMessages()
            print("   Messages saved to disk")
            print("✅ SEND COMPLETE!")
            print("💾 ========== SEND VIDEO MESSAGE END (SUCCESS) ==========")
        } catch {
            print("❌ Error saving video message: \(error)")
            print("   Error details: \(error.localizedDescription)")
            temporaryVideoURL = nil
            print("💾 ========== SEND VIDEO MESSAGE END (ERROR) ==========")
        }
    }
    
    func deleteMessage(_ message: VideoMessage) {
        try? fileManager.removeItem(at: message.videoURL)
        videoMessages.removeAll { $0.id == message.id }
        saveMessages()
    }
    
    func markAsViewed(_ message: VideoMessage) {
        guard let index = videoMessages.firstIndex(where: { $0.id == message.id }) else { return }
        videoMessages[index].isViewed = true
        videoMessages[index].viewedDate = Date()
        saveMessages()
    }
    
    func updateMessage(_ message: VideoMessage, title: String, messageText: String) {
        guard let index = videoMessages.firstIndex(where: { $0.id == message.id }) else { return }
        videoMessages[index].title = title
        videoMessages[index].message = messageText
        saveMessages()
    }
    
    // MARK: - Query Functions
    
    func getMessages(for clientId: String) -> [VideoMessage] {
        return videoMessages
            .filter { $0.clientId == clientId }
            .sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func getUnviewedCount(for clientId: String) -> Int {
        return videoMessages
            .filter { $0.clientId == clientId && !$0.isViewed }
            .count
    }
    
    func getRecentMessages(for clientId: String, limit: Int = 5) -> [VideoMessage] {
        return Array(getMessages(for: clientId).prefix(limit))
    }
    
    func getMessagesByType(for clientId: String, type: VideoMessage.MessageType) -> [VideoMessage] {
        return videoMessages
            .filter { $0.clientId == clientId && $0.messageType == type }
            .sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func getAllUnviewedMessages() -> [VideoMessage] {
        return videoMessages
            .filter { !$0.isViewed }
            .sorted { $0.dateCreated > $1.dateCreated }
    }
    
    // MARK: - Persistence
    
    private var messagesFileURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("videoMessages.json")
    }
    
    private func saveMessages() {
        guard let data = try? JSONEncoder().encode(videoMessages) else { return }
        try? data.write(to: messagesFileURL)
    }
    
    private func loadMessages() {
        guard fileManager.fileExists(atPath: messagesFileURL.path),
              let data = try? Data(contentsOf: messagesFileURL),
              let messages = try? JSONDecoder().decode([VideoMessage].self, from: data)
        else {
            // Load sample data for testing
            self.videoMessages = VideoMessage.sampleMessages
            return
        }
        self.videoMessages = messages
    }
}
