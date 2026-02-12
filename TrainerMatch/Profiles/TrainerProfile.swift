//
//  TrainerProfile.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct TrainerProfileMySpaceView: View {
    let trainer: TrainerProfile
    @State private var selectedTab: ProfileTab = .about
    
    enum ProfileTab {
        case about, clients, photos, contact
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Banner with Profile Photo
                ZStack(alignment: .bottomLeading) {
                    // Background banner
                    LinearGradient(
                        colors: [Color.tmGold, Color.tmGoldDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)
                    
                    // Profile Photo (overlapping banner)
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
                
                // Name and Status
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trainer.businessName ?? "Personal Trainer")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(trainer.isVerified ? Color.green : Color.orange)
                                    .frame(width: 10, height: 10)
                                
                                Text(trainer.isVerified ? "Verified Trainer" : "Active")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        // Quick Stats
                        VStack(spacing: 8) {
                            if let rating = trainer.rating {
                                StatBubble(icon: "star.fill", value: String(format: "%.1f", rating), label: "Rating")
                            }
                            StatBubble(icon: "calendar", value: "\(trainer.yearsOfExperience)", label: "Years")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    // Location and Service Type
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
                .padding(.bottom, 20)
                .background(Color.black)
                
                // Tab Navigation
                HStack(spacing: 0) {
                    ProfileTabButton(
                        icon: "person.circle.fill",
                        title: "ABOUT ME",
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
                        icon: "photo.fill",
                        title: "PHOTOS",
                        isSelected: selectedTab == .photos,
                        action: { selectedTab = .photos }
                    )
                    
                    ProfileTabButton(
                        icon: "envelope.fill",
                        title: "CONTACT",
                        isSelected: selectedTab == .contact,
                        action: { selectedTab = .contact }
                    )
                }
                .background(Color.white.opacity(0.05))
                
                // Content Based on Selected Tab
                switch selectedTab {
                case .about:
                    AboutMeSection(trainer: trainer)
                case .clients:
                    ClientsSection(trainer: trainer)
                case .photos:
                    PhotosSection(trainer: trainer)
                case .contact:
                    ContactSection(trainer: trainer)
                }
            }
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
                    .foregroundColor(isSelected ? .tmGold : .white.opacity(0.5))
                
                Text(title)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(isSelected ? .tmGold : .white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? Color.tmGold.opacity(0.1) : Color.clear
            )
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

// MARK: - About Me Section
struct AboutMeSection: View {
    let trainer: TrainerProfile
    
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "ABOUT ME", icon: "person.fill") {
                VStack(alignment: .leading, spacing: 12) {
                    if let location = trainer.location {
                        InfoRow(label: "Hometown", value: "\(location.city), \(location.state)")
                    }
                    InfoRow(label: "Experience", value: "\(trainer.yearsOfExperience) years")
                    if let rate = trainer.hourlyRate {
                        InfoRow(label: "Hourly Rate", value: "$\(Int(rate))/hour")
                    }
                    InfoRow(label: "Specialties", value: trainer.specialties.map { $0.rawValue }.joined(separator: ", "))
                }
            }
            
            if let bio = trainer.bio {
                InfoCard(title: "BIO", icon: "text.quote") {
                    Text(bio)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
            }
            
            if !trainer.certifications.isEmpty {
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
        .padding(20)
    }
}

// MARK: - Clients Section
struct ClientsSection: View {
    let trainer: TrainerProfile
    
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "MY STATS", icon: "chart.bar.fill") {
                VStack(spacing: 12) {
                    if let rating = trainer.rating {
                        Text(String(format: "%.1f", rating))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.tmGold)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                                    .font(.caption)
                                    .foregroundColor(.tmGold)
                            }
                        }
                        
                        Text("\(trainer.totalReviews) Reviews")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.vertical, 8)
                    
                    // Sample client testimonials
                    VStack(spacing: 16) {
                        TestimonialCard(
                            clientName: "Sarah M.",
                            text: "Best trainer I've ever worked with! Lost 30 lbs and gained so much confidence.",
                            rating: 5
                        )
                        
                        TestimonialCard(
                            clientName: "Mike R.",
                            text: "Professional, knowledgeable, and motivating. Highly recommend!",
                            rating: 5
                        )
                    }
                }
            }
        }
        .padding(20)
    }
}

// MARK: - Photos Section
struct PhotosSection: View {
    let trainer: TrainerProfile
    
    let samplePhotos = [
        "dumbbell.fill", "figure.strengthtraining.traditional",
        "figure.yoga", "figure.run", "figure.core.training",
        "sportscourt.fill"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "PHOTO GALLERY", icon: "photo.on.rectangle.angled") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(samplePhotos, id: \.self) { photo in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.tmGold.opacity(0.3), Color.tmGoldDark.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 100)
                            
                            Image(systemName: photo)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
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
        .padding(20)
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

struct TestimonialCard: View {
    let clientName: String
    let text: String
    let rating: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.tmGold)
                }
            }
            
            Text("\" \(text) \"")
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .italic()
            
            Text("- \(clientName)")
                .font(.caption)
                .foregroundColor(.tmGold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.tmGold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
}

#Preview {
    NavigationView {
        TrainerProfileMySpaceView(trainer: TrainerProfile.sampleProfile)
    }
}
