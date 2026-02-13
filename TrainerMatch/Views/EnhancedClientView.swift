//
//  EnhancedClientView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  EnhancedClientDetailView.swift
//  TrainerMatch
//
//  Enhanced client detail view with video messaging capabilities
//

//
//  EnhancedClientDetailView.swift
//  TrainerMatch
//
//  Enhanced client detail view with video messaging capabilities
//

//
//  EnhancedClientDetailView.swift
//  TrainerMatch
//
//  Enhanced client detail view with video messaging capabilities
//

import SwiftUI

struct EnhancedClientDetailView: View {
    @ObservedObject var trainerViewModel: TrainerViewModel
    @StateObject var videoMessageViewModel = VideoMessageViewModel()
    let client: Client
    
    @State private var showingVideoCamera = false
    @State private var showingAllMessages = false
    @State private var selectedTab = 0
    
    var stats: ClientStats {
        trainerViewModel.getClientStats(for: client)
    }
    
    var recentMessages: [VideoMessage] {
        videoMessageViewModel.getRecentMessages(for: client.id, limit: 3)
    }
    
    var unviewedMessageCount: Int {
        videoMessageViewModel.getUnviewedCount(for: client.id)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Client header
                    ClientHeaderSection(client: client, stats: stats)
                    
                    // Quick actions with video message button
                    QuickActionsSection(
                        onSendVideo: { showingVideoCamera = true },
                        onViewMessages: { showingAllMessages = true },
                        unviewedCount: unviewedMessageCount
                    )
                    
                    // Recent video messages
                    if !recentMessages.isEmpty {
                        RecentMessagesSection(
                            messages: recentMessages,
                            viewModel: videoMessageViewModel,
                            onViewAll: { showingAllMessages = true }
                        )
                    }
                    
                    // Existing client stats and info
                    ClientStatsSection(stats: stats)
                    
                    // Activity tracking
                    ActivitySection(client: client)
                    
                    // Recent progress
                    ProgressSection(
                        entries: trainerViewModel.getProgressEntries(for: client)
                    )
                }
                .padding()
            }
        }
        .navigationTitle(client.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingVideoCamera = true }) {
                        Label("Send Video Message", systemImage: "video.fill")
                    }
                    Button(action: { showingAllMessages = true }) {
                        Label("View All Messages", systemImage: "message.fill")
                    }
                    Divider()
                    Button(action: {}) {
                        Label("Edit Client", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.tmGold)
                }
            }
        }
        .sheet(isPresented: $showingVideoCamera) {
            VideoMessageCameraView(
                viewModel: videoMessageViewModel,
                clientName: client.name,
                clientId: client.id
            )
        }
        .sheet(isPresented: $showingAllMessages) {
            NavigationView {
                ClientVideoMessagesView(
                    viewModel: videoMessageViewModel,
                    clientId: client.id,
                    clientName: client.name
                )
            }
        }
    }
}

// MARK: - Supporting Sections

struct ClientHeaderSection: View {
    let client: Client
    let stats: ClientStats
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile image placeholder
            Circle()
                .fill(Color.tmGold.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.tmGold)
                )
            
            VStack(spacing: 4) {
                Text(client.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(client.email)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: 16) {
                    Label("\(stats.daysActive) days", systemImage: "calendar")
                    if let foundVia = client.foundVia {
                        Label(foundVia, systemImage: "link")
                    }
                }
                .font(.caption)
                .foregroundColor(.tmGold)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

struct QuickActionsSection: View {
    let onSendVideo: () -> Void
    let onViewMessages: () -> Void
    let unviewedCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                // Send video message button
                Button(action: onSendVideo) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.tmGoldGradient())
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "video.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        
                        Text("Send Video")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                // View messages button
                Button(action: onViewMessages) {
                    VStack(spacing: 8) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "message.fill")
                                .font(.title2)
                                .foregroundColor(.tmGold)
                            
                            if unviewedCount > 0 {
                                Text("\(unviewedCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                        
                        Text("Messages")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

struct RecentMessagesSection: View {
    let messages: [VideoMessage]
    @ObservedObject var viewModel: VideoMessageViewModel
    let onViewAll: () -> Void
    
    @State private var selectedMessage: VideoMessage?
    @State private var showingPlayer = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Recent Video Messages")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onViewAll) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.tmGold)
                }
            }
            
            ForEach(messages) { message in
                MessagePreviewCard(message: message) {
                    selectedMessage = message
                    showingPlayer = true
                    if !message.isViewed {
                        viewModel.markAsViewed(message)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
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

struct MessagePreviewCard: View {
    let message: VideoMessage
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.tmGold)
                    
                    if message.isNew {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack {
                        Text(message.messageType.rawValue)
                            .font(.caption)
                            .foregroundColor(.tmGold)
                        Text("•")
                            .foregroundColor(.white.opacity(0.5))
                        Text(message.timeAgo)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                
                Spacer()
                
                Text(message.formattedDuration)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

struct ClientStatsSection: View {
    let stats: ClientStats
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ClientStatCard(
                    title: "Total Workouts",
                    value: "\(stats.totalWorkouts)",
                    icon: "figure.strengthtraining.traditional"
                )
                ClientStatCard(
                    title: "Completion Rate",
                    value: String(format: "%.0f%%", stats.completionRate),
                    icon: "chart.line.uptrend.xyaxis"
                )
                ClientStatCard(
                    title: "Active Workouts",
                    value: "\(stats.activeWorkouts)",
                    icon: "flame.fill"
                )
                if let weightChange = stats.weightChange {
                    ClientStatCard(
                        title: "Weight Change",
                        value: String(format: "%.1f kg", weightChange),
                        icon: "scalemass.fill",
                        isPositive: weightChange < 0
                    )
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

struct ClientStatCard: View {
    let title: String
    let value: String
    let icon: String
    var isPositive: Bool = true
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.tmGold)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ActivitySection: View {
    let client: Client
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Activity Tracking")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ActivityCard(
                    title: "Steps Today",
                    value: "\(client.dailySteps)",
                    icon: "figure.walk",
                    color: .green
                )
                
                ActivityCard(
                    title: "Distance",
                    value: String(format: "%.1f km", client.dailyDistance),
                    icon: "map",
                    color: .blue
                )
            }
            
            HStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(statusColor(for: client.activityStatus))
                    .font(.caption)
                Text(client.activityStatus)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                if let lastSync = client.lastSyncDate {
                    Text("Synced \(timeAgo(lastSync))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    private func statusColor(for status: String) -> Color {
        switch status {
        case "Very Active": return .green
        case "Active": return .yellow
        case "Lightly Active": return .orange
        default: return .red
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let minutes = Int(Date().timeIntervalSince(date) / 60)
        if minutes < 60 {
            return "\(minutes)m ago"
        } else {
            let hours = minutes / 60
            return "\(hours)h ago"
        }
    }
}

struct ActivityCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ProgressSection: View {
    let entries: [ProgressEntry]
    
    var body: some View {
        if !entries.isEmpty {
            VStack(spacing: 12) {
                Text("Recent Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(entries.prefix(3)) { entry in
                    ProgressEntryRow(entry: entry)
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
        }
    }
}

struct ProgressEntryRow: View {
    let entry: ProgressEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                if let weight = entry.weight {
                    Text("\(String(format: "%.1f", weight)) kg")
                        .font(.caption)
                        .foregroundColor(.tmGold)
                }
            }
            
            Spacer()
            
            if let notes = entry.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationView {
        EnhancedClientDetailView(
            trainerViewModel: TrainerViewModel(),
            client: Client.sampleClients[0]
        )
    }
}
