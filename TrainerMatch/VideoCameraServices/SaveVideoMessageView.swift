//
//  SaveVideoMessageView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  SaveVideoMessageView.swift
//  TrainerMatch
//
//  View for adding title, message, and type before sending video message
//

import SwiftUI
import AVKit

struct SaveVideoMessageView: View {
    @Binding var title: String
    @Binding var message: String
    @Binding var messageType: VideoMessage.MessageType
    let clientName: String
    @ObservedObject var viewModel: VideoMessageViewModel
    let onSend: () -> Void
    let onCancel: () -> Void
    
    @State private var player: AVPlayer?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Video preview
                        if let url = viewModel.temporaryVideoURL {
                            VideoPlayer(player: player)
                                .frame(height: 250)
                                .cornerRadius(16)
                                .onAppear {
                                    player = AVPlayer(url: url)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.tmGold, lineWidth: 2)
                                )
                        }
                        
                        VStack(spacing: 20) {
                            // Recipient info
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.tmGold)
                                Text("Sending to:")
                                    .foregroundColor(.white.opacity(0.7))
                                Text(clientName)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            
                            // Message type picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Message Type")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.tmGold)
                                
                                Menu {
                                    ForEach([VideoMessage.MessageType.progressFeedback,
                                            .workoutInstructions,
                                            .motivational,
                                            .checkIn,
                                            .formCorrection,
                                            .general], id: \.self) { type in
                                        Button(action: { messageType = type }) {
                                            HStack {
                                                Text(type.rawValue)
                                                if messageType == type {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: iconForMessageType(messageType))
                                            .foregroundColor(.tmGold)
                                        Text(messageType.rawValue)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Title field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.tmGold)
                                
                                TextField("", text: $title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.tmGold.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            // Message field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Message")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.tmGold)
                                
                                TextEditor(text: $message)
                                    .foregroundColor(.white)
                                    .frame(height: 120)
                                    .padding(8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.tmGold.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Action buttons
                        VStack(spacing: 12) {
                            Button(action: {
                                onSend()
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                    Text("SEND VIDEO MESSAGE")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.tmGoldGradient())
                                )
                                .foregroundColor(.black)
                                .shadow(color: .tmGold.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                            .disabled(title.isEmpty)
                            
                            Button(action: {
                                onCancel()
                                dismiss()
                            }) {
                                Text("Cancel & Discard")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Review Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                    .foregroundColor(.tmGold)
                }
            }
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
