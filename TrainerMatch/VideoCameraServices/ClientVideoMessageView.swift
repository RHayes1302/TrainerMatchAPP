//
//  ClientVideoMessageView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  ClientVideoMessagesView.swift
//  TrainerMatch
//
//  View showing all video messages sent to a client
//

import SwiftUI
import AVKit

struct ClientVideoMessagesView: View {
    @ObservedObject var viewModel: VideoMessageViewModel
    let clientId: String
    let clientName: String
    
    @State private var selectedMessage: VideoMessage?
    @State private var showingPlayer = false
    @State private var filterType: VideoMessage.MessageType?
    
    var filteredMessages: [VideoMessage] {
        let messages = viewModel.getMessages(for: clientId)
        if let type = filterType {
            return messages.filter { $0.messageType == type }
        }
        return messages
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Video Messages")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("for \(clientName)")
                                .font(.subheadline)
                                .foregroundColor(.tmGold)
                        }
                        Spacer()
                        
                        // Unviewed count badge
                        let unviewedCount = viewModel.getUnviewedCount(for: clientId)
                        if unviewedCount > 0 {
                            Text("\(unviewedCount)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.tmGold)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Filter buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            FilterButton(
                                title: "All",
                                isSelected: filterType == nil,
                                action: { filterType = nil }
                            )
                            
                            ForEach([VideoMessage.MessageType.progressFeedback,
                                    .workoutInstructions,
                                    .motivational,
                                    .checkIn,
                                    .formCorrection], id: \.self) { type in
                                FilterButton(
                                    title: type.rawValue,
                                    isSelected: filterType == type,
                                    action: { filterType = type }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                }
                .background(Color.white.opacity(0.05))
                
                // Messages list
                if filteredMessages.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "video.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Text("No messages yet")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.6))
                        if filterType != nil {
                            Text("Try selecting a different filter")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredMessages) { message in
                                VideoMessageCard(message: message) {
                                    selectedMessage = message
                                    showingPlayer = true
                                    if !message.isViewed {
                                        viewModel.markAsViewed(message)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPlayer) {
            if let message = selectedMessage {
                VideoMessagePlayerView(
                    message: message,
                    onClose: { showingPlayer = false }
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.tmGold : Color.white.opacity(0.1))
                )
        }
    }
}

struct VideoMessageCard: View {
    let message: VideoMessage
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Thumbnail placeholder with play button
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.05))
                        .aspectRatio(16/9, contentMode: .fit)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.tmGold)
                        
                        Text(message.formattedDuration)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(12)
                    }
                    
                    // New badge
                    if message.isNew {
                        VStack {
                            HStack {
                                Text("NEW")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.tmGold)
                                    .cornerRadius(8)
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding(12)
                    }
                }
                
                // Message info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: iconForMessageType(message.messageType))
                            .foregroundColor(.tmGold)
                            .font(.caption)
                        Text(message.messageType.rawValue)
                            .font(.caption)
                            .foregroundColor(.tmGold)
                        Spacer()
                        Text(message.timeAgo)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Text(message.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(message.message)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                .padding()
            }
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(message.isNew ? Color.tmGold : Color.white.opacity(0.1), lineWidth: message.isNew ? 2 : 1)
            )
        }
    }
    
    private func iconForMessageType(_ type: VideoMessage.MessageType) -> String {
        switch type {
        case .progressFeedback:
            return "chart.line.uptrend.xyaxis"
        case .workoutInstructions:
            return "figure.strengthtraining.traditional"
        case .motivational:
            return "flame.fill"
        case .checkIn:
            return "checkmark.circle.fill"
        case .formCorrection:
            return "eye.fill"
        case .general:
            return "message.fill"
        }
    }
}

struct VideoMessagePlayerView: View {
    let message: VideoMessage
    let onClose: () -> Void
    
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding()
                
                // Video player
                if let player = player {
                    VideoPlayer(player: player)
                        .onAppear {
                            player.play()
                        }
                }
                
                // Message details
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: iconForMessageType(message.messageType))
                            .foregroundColor(.tmGold)
                        Text(message.messageType.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.tmGold)
                        Spacer()
                        Text(message.formattedDate)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Text(message.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(message.message)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(Color.white.opacity(0.05))
            }
        }
        .onAppear {
            player = AVPlayer(url: message.videoURL)
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    private func iconForMessageType(_ type: VideoMessage.MessageType) -> String {
        switch type {
        case .progressFeedback: return "chart.line.uptrend.xyaxis"
        case .workoutInstructions: return "figure.strengthtraining.traditional"
        case .motivational: return "flame.fill"
        case .checkIn: return "checkmark.circle.fill"
        case .formCorrection: return "eye.fill"
        case .general: return "message.fill"
        }
    }
}

#Preview {
    NavigationView {
        ClientVideoMessagesView(
            viewModel: VideoMessageViewModel(),
            clientId: "client1",
            clientName: "John Doe"
        )
    }
}
