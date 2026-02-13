
//
//  ClientProfile.swift (SAFE VERSION)
//  TrainerMatch
//
//  Fixed version with safety checks
//

import SwiftUI

struct ClientProfileMySpaceView: View {
    let client: ClientProfile
    @State private var selectedTab: ClientProfileTab = .about
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    enum ClientProfileTab: String {
        case about = "About"
        case goals = "Goals"
        case health = "Health"
        case progress = "Progress"
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    tabNavigation
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
    
    private var headerSection: some View {
        VStack(spacing: 0) {
            // Gold Banner
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color.tmGold, Color.tmGoldDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                
                // Profile Circle
                HStack {
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
                            Text(client.name.prefix(1).uppercased())
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
            
            // Name and Info
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(client.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                            Text("Active Member")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.tmGold)
                        Text("\(client.city), \(client.state)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.tmGold)
                        Text(client.fitnessLevel)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
            .background(Color.black)
        }
    }
    
    private var tabNavigation: some View {
        HStack(spacing: 0) {
            ForEach([ClientProfileTab.about, .goals, .health, .progress], id: \.self) { tab in
                Button(action: {
                    print("📌 Tab tapped: \(tab.rawValue)")
                    withAnimation {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: iconFor(tab))
                            .font(.caption)
                        Text(tab.rawValue.uppercased())
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundColor(selectedTab == tab ? .tmGold : .white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedTab == tab ? Color.tmGold.opacity(0.1) : Color.clear)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.white.opacity(0.05))
    }
    
    @ViewBuilder
    private var tabContent: some View {
        Group {
            switch selectedTab {
            case .about:
                aboutContent
            case .goals:
                goalsContent
            case .health:
                healthContent
            case .progress:
                progressContent
            }
        }
        .padding(20)
    }
    
    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("About")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ClientInfoRow(label: "Age", value: "\(client.age)")
            ClientInfoRow(label: "Member Since", value: formattedDate(client.memberSince))
            ClientInfoRow(label: "Fitness Level", value: client.fitnessLevel)
            ClientInfoRow(label: "Preferred Training", value: client.preferredServiceType.rawValue)
            
            if let trainer = client.currentTrainer {
                ClientInfoRow(label: "Current Trainer", value: trainer)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.vertical, 8)
            
            // Health Tracker Link
            NavigationLink(destination: ContentView()) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "heart.text.square.fill")
                                .font(.title2)
                                .foregroundColor(.tmGold)
                            Text("Health Tracker")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Text("Track your nutrition, water, sleep, and workouts")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.tmGold)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.tmGold, lineWidth: 1)
                        )
                )
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.vertical, 8)
            
            // Account Settings
            Text("Account")
                .font(.headline)
                .foregroundColor(.tmGold)
            
            // Logout Button
            Button(action: {
                authManager.logout()
                dismiss()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title3)
                        .foregroundColor(.red)
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.5), lineWidth: 1)
                        )
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var goalsContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Fitness Goals")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if client.goals.isEmpty {
                Text("No goals set yet")
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(client.goals.enumerated()), id: \.offset) { index, goal in
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.tmGold)
                            Text(String(describing: goal))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.vertical, 8)
            
            Text("Weight Goals")
                .font(.headline)
                .foregroundColor(.tmGold)
            
            HStack(spacing: 20) {
                VStack {
                    Text("Starting")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(client.startingWeight) lbs")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.tmGold)
                
                VStack {
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(client.currentWeight) lbs")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.tmGold)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.white.opacity(0.3))
                
                VStack {
                    Text("Target")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(client.targetWeight) lbs")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var healthContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Health Information")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ClientHealthInfoSection(title: "Medical Conditions", content: client.medicalConditions)
            ClientHealthInfoSection(title: "Injuries", content: client.injuries)
            ClientHealthInfoSection(title: "Allergies", content: client.allergies)
            ClientHealthInfoSection(title: "Medications", content: client.medications)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var progressContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Health Tracker Link
            NavigationLink(destination: ContentView()) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.title2)
                                .foregroundColor(.tmGold)
                            Text("Open Health Tracker")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Text("View detailed daily tracking")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.tmGold)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.tmGold.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.tmGold, lineWidth: 2)
                        )
                )
            }
            .padding(.bottom, 10)
            
            HStack(spacing: 20) {
                ClientProgressCard(
                    icon: "flame.fill",
                    value: "\(client.currentStreak)",
                    label: "Day Streak",
                    color: .orange
                )
                
                ClientProgressCard(
                    icon: "checkmark.circle.fill",
                    value: "\(client.workoutsCompleted)",
                    label: "Total Workouts",
                    color: .green
                )
            }
            
            ClientProgressCard(
                icon: "calendar.badge.clock",
                value: "\(client.workoutsThisWeek)",
                label: "This Week",
                color: .tmGold
            )
            
            ClientProgressCard(
                icon: "photo.fill",
                value: "\(client.progressPhotoCount)",
                label: "Progress Photos",
                color: .blue
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func iconFor(_ tab: ClientProfileTab) -> String {
        switch tab {
        case .about: return "person.circle.fill"
        case .goals: return "target"
        case .health: return "heart.text.square.fill"
        case .progress: return "chart.xyaxis.line"
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct ClientInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.6))
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 8)
    }
}

struct ClientHealthInfoSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.tmGold)
            
            Text(content.isEmpty ? "None reported" : content)
                .foregroundColor(.white.opacity(0.8))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                )
        }
    }
}

struct ClientProgressCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - Client Profile Model
struct ClientProfile {
    let name: String
    let age: Int
    let city: String
    let state: String
    let memberSince: Date
    let currentTrainer: String?
    let preferredServiceType: ServiceType
    let fitnessLevel: String
    let goals: [FitnessGoal]
    let startingWeight: Int
    let currentWeight: Int
    let targetWeight: Int
    let medicalConditions: String
    let injuries: String
    let allergies: String
    let medications: String
    let currentStreak: Int
    let workoutsCompleted: Int
    let workoutsThisWeek: Int
    let progressPhotoCount: Int
    let measurements: ClientMeasurements
    
    struct ClientMeasurements {
        let chest: Double
        let waist: Double
        let hips: Double
        let arms: Double
    }
    
    static let sample = ClientProfile(
        name: "Nick Thomas",
        age: 32,
        city: "Las Vegas",
        state: "NV",
        memberSince: Date().addingTimeInterval(-90 * 24 * 60 * 60),
        currentTrainer: "Mario Kutz",
        preferredServiceType: .inPerson,
        fitnessLevel: "Intermediate",
        goals: [.weightLoss, .muscleGain, .generalFitness],
        startingWeight: 220,
        currentWeight: 195,
        targetWeight: 180,
        medicalConditions: "Mild asthma (well-controlled with inhaler)",
        injuries: "Previous right knee injury (ACL repair 2 years ago). Occasional lower back stiffness.",
        allergies: "Pollen, dust",
        medications: "Albuterol inhaler (as needed)",
        currentStreak: 12,
        workoutsCompleted: 45,
        workoutsThisWeek: 3,
        progressPhotoCount: 8,
        measurements: ClientMeasurements(
            chest: 42.5,
            waist: 34.0,
            hips: 38.5,
            arms: 15.5
        )
    )
}

#Preview {
    NavigationView {
        ClientProfileMySpaceView(client: ClientProfile.sample)
    }
}
