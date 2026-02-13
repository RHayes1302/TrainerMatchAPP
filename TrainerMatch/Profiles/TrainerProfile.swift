//
//  TrainerProfile.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

//
//  TrainerProfile_ENHANCED.swift
//  TrainerMatch
//
//  Enhanced with logout, better stats, and improved layout
//

//
//  TrainerProfile_FIXED.swift
//  TrainerMatch
//
//  Fixed version matching actual model
//

import SwiftUI

struct TrainerProfileMySpaceView: View {
    let trainer: TrainerProfile
    @State private var selectedTab: ProfileTab = .about
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    enum ProfileTab {
        case about, clients, schedule, contact
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    tabBar
                    tabContent
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    authManager.logout()
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                    .foregroundColor(.tmGold)
                }
            }
        }
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            headerBanner
            nameAndStatus
        }
    }
    
    private var headerBanner: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.tmGold, Color.tmGoldDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            
            HStack(spacing: 16) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.tmGold, Color.tmGoldDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text(trainer.businessName?.prefix(1) ?? "T")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.black)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 4)
                    )
                    .offset(y: 40)
                    .padding(.leading, 20)
                
                Spacer()
            }
        }
        .frame(height: 240)
    }
    
    private var nameAndStatus: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trainer.businessName ?? "Personal Trainer")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    statusBadge
                }
                Spacer()
                quickStats
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
            
            locationAndService
        }
        .padding(.bottom, 20)
        .background(Color.black)
    }
    
    private var statusBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(trainer.isVerified ? Color.green : Color.orange)
                .frame(width: 10, height: 10)
            
            Text(trainer.isVerified ? "Verified Trainer" : "Active")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var quickStats: some View {
        VStack(spacing: 8) {
            if let rating = trainer.rating {
                StatBubble(
                    icon: "star.fill",
                    value: String(format: "%.1f", rating),
                    label: "Rating"
                )
            }
            StatBubble(
                icon: "calendar",
                value: "\(trainer.yearsOfExperience)",
                label: "Years"
            )
        }
    }
    
    private var locationAndService: some View {
        HStack(spacing: 16) {
            if let location = trainer.location {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.tmGold)
                    Text("\(location.city), \(location.state)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            if let serviceType = trainer.serviceTypes.first {
                HStack(spacing: 6) {
                    Image(systemName: "dumbbell.fill")
                        .foregroundColor(.tmGold)
                    Text(serviceType.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Tab Bar
    private var tabBar: some View {
        HStack(spacing: 0) {
            ProfileTabButton(
                icon: "person.circle.fill",
                title: "PROFILE",
                isSelected: selectedTab == .about,
                action: { selectedTab = .about }
            )
            
            ProfileTabButton(
                icon: "person.2.fill",
                title: "CLIENTS",
                isSelected: selectedTab == .clients,
                action: { selectedTab = .clients }
            )
            
            ProfileTabButton(
                icon: "calendar",
                title: "SCHEDULE",
                isSelected: selectedTab == .schedule,
                action: { selectedTab = .schedule }
            )
            
            ProfileTabButton(
                icon: "envelope.fill",
                title: "CONTACT",
                isSelected: selectedTab == .contact,
                action: { selectedTab = .contact }
            )
        }
        .background(Color.white.opacity(0.05))
    }
    
    // MARK: - Tab Content
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .about:
            AboutMeSection(trainer: trainer)
        case .clients:
            ClientsSection(trainer: trainer)
        case .schedule:
            ScheduleSection()
        case .contact:
            ContactSection(trainer: trainer)
        }
    }
}

// MARK: - Stat Bubble
struct StatBubble: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.tmGold)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// MARK: - Profile Tab Button
struct ProfileTabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundColor(isSelected ? .tmGold : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.tmGold.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - About Me Section
struct AboutMeSection: View {
    let trainer: TrainerProfile
    
    var body: some View {
        VStack(spacing: 20) {
            professionalInfo
            
            if let bio = trainer.bio, !bio.isEmpty {
                bioCard
            }
            
            if !trainer.specialties.isEmpty {
                specialtiesCard
            }
            
            if !trainer.serviceTypes.isEmpty {
                servicesCard
            }
            
            if !trainer.certifications.isEmpty {
                certificationsCard
            }
        }
        .padding(20)
    }
    
    private var professionalInfo: some View {
        InfoCard(title: "PROFESSIONAL INFO", icon: "briefcase.fill") {
            VStack(alignment: .leading, spacing: 12) {
                if let location = trainer.location {
                    InfoRow(label: "Location", value: "\(location.city), \(location.state)")
                }
                InfoRow(label: "Experience", value: "\(trainer.yearsOfExperience) years")
                
                if let rate = trainer.hourlyRate {
                    InfoRow(label: "Hourly Rate", value: "$\(Int(rate))/hour")
                }
            }
        }
    }
    
    private var bioCard: some View {  // ✅ Flexible type
        InfoCard(title: "ABOUT ME", icon: "text.quote") {
            Text(trainer.bio ?? "")
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
    
    private var specialtiesCard: some View {
        InfoCard(title: "SPECIALTIES", icon: "star.circle.fill") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(trainer.specialties, id: \.self) { specialty in
                    Text("• \(specialty.rawValue)")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var servicesCard: some View {
        InfoCard(title: "SERVICES", icon: "checkmark.circle.fill") {
            VStack(spacing: 10) {
                ForEach(trainer.serviceTypes, id: \.self) { service in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.tmGold)
                        Text(service.rawValue)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var certificationsCard: some View {
        InfoCard(title: "CERTIFICATIONS", icon: "checkmark.seal.fill") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(trainer.certifications, id: \.self) { cert in
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.tmGold)
                        Text(cert)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

// MARK: - Clients Section
struct ClientsSection: View {
    let trainer: TrainerProfile
    
    var body: some View {
        VStack(spacing: 20) {
            statsCard
            noClientsPlaceholder
        }
        .padding(20)
    }
    
    private var statsCard: some View {
        InfoCard(title: "MY STATS", icon: "chart.bar.fill") {
            VStack(spacing: 12) {
                if let rating = trainer.rating {
                    ratingDisplay
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.vertical, 8)
                
                clientCountDisplay
            }
        }
    }
    
    private var ratingDisplay: some View {
        VStack(spacing: 8) {
            Text(String(format: "%.1f", trainer.rating ?? 5.0))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.tmGold)
            
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(trainer.rating ?? 5.0) ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(.tmGold)
                }
            }
            
            Text("\(trainer.totalReviews) Reviews")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var clientCountDisplay: some View {
        HStack(spacing: 30) {
            VStack {
                Text("0")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Active")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack {
                Text("0")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Total")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    private var noClientsPlaceholder: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.tmGold.opacity(0.5))
            
            Text("No Clients Yet")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Start building your client base!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(40)
    }
}

// MARK: - Schedule Section
struct ScheduleSection: View {
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "SCHEDULE", icon: "calendar.badge.clock") {
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 60))
                        .foregroundColor(.tmGold.opacity(0.5))
                    
                    Text("No Sessions Scheduled")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Your upcoming training sessions will appear here")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 30)
            }
        }
        .padding(20)
    }
}

// MARK: - Contact Section
struct ContactSection: View {
    let trainer: TrainerProfile
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            contactInfoCard
            messageCard
        }
        .padding(20)
    }
    
    private var contactInfoCard: some View {
        InfoCard(title: "CONTACT INFO", icon: "envelope.fill") {
            VStack(alignment: .leading, spacing: 12) {
                if let location = trainer.location {
                    ContactRow(icon: "mappin.circle.fill", value: "\(location.city), \(location.state)")
                }
                
                if let website = trainer.websiteURL {
                    ContactRow(icon: "globe", value: website)
                }
                
                if let instagram = trainer.instagramHandle {
                    ContactRow(icon: "camera.fill", value: "@\(instagram)")
                }
            }
        }
    }
    
    private var messageCard: some View {
        InfoCard(title: "SEND MESSAGE", icon: "paperplane.fill") {
            VStack(spacing: 16) {
                TextEditor(text: $message)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                
                Button(action: {}) {
                    Text("SEND MESSAGE")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.tmGold)
                        )
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct InfoCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.caption)
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.tmGold)
            
            content
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.tmGold)
            Text(value)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct ContactRow: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.tmGold)
                .frame(width: 24)
            
            Text(value)
                .font(.body)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NavigationView {
        TrainerProfileMySpaceView(trainer: TrainerProfile.sampleProfile)
            .environmentObject(AuthManager.shared)
    }
}
