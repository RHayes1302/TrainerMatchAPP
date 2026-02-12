//
//  ClientProfile.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct ClientProfileMySpaceView: View {
    let client: ClientProfile
    @State private var selectedTab: ClientProfileTab = .about
    
    enum ClientProfileTab {
        case about, goals, health, progress
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
                    
                    // Profile Photo
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
                                Text(client.name.prefix(1))
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
                        
                        // Quick Stats
                        VStack(spacing: 8) {
                            ClientStatBubble(icon: "flame.fill", value: "\(client.currentStreak)", label: "Day Streak")
                            ClientStatBubble(icon: "checkmark.circle.fill", value: "\(client.workoutsCompleted)", label: "Workouts")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    // Location and Fitness Level
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
                
                // Tab Navigation
                HStack(spacing: 0) {
                    ClientProfileTabButton(
                        icon: "person.circle.fill",
                        title: "ABOUT",
                        isSelected: selectedTab == .about,
                        action: { selectedTab = .about }
                    )
                    
                    ClientProfileTabButton(
                        icon: "target",
                        title: "GOALS",
                        isSelected: selectedTab == .goals,
                        action: { selectedTab = .goals }
                    )
                    
                    ClientProfileTabButton(
                        icon: "heart.text.square.fill",
                        title: "HEALTH",
                        isSelected: selectedTab == .health,
                        action: { selectedTab = .health }
                    )
                    
                    ClientProfileTabButton(
                        icon: "chart.xyaxis.line",
                        title: "PROGRESS",
                        isSelected: selectedTab == .progress,
                        action: { selectedTab = .progress }
                    )
                }
                .background(Color.white.opacity(0.05))
                
                // Content Based on Selected Tab
                switch selectedTab {
                case .about:
                    ClientAboutSection(client: client)
                case .goals:
                    ClientProfileGoalsSection(client: client)
                case .health:
                    ClientProfileHealthSection(client: client)
                case .progress:
                    ClientProgressSection(client: client)
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

// MARK: - Client Profile Tab Button
struct ClientProfileTabButton: View {
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

// MARK: - Client Stat Bubble
struct ClientStatBubble: View {
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

// MARK: - Client About Section
struct ClientAboutSection: View {
    let client: ClientProfile
    
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "PERSONAL INFO", icon: "person.fill") {
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(label: "Age", value: "\(client.age)")
                    InfoRow(label: "Location", value: "\(client.city), \(client.state)")
                    InfoRow(label: "Member Since", value: client.memberSince.formatted(date: .abbreviated, time: .omitted))
                    InfoRow(label: "Preferred Training", value: client.preferredServiceType.rawValue)
                    InfoRow(label: "Fitness Level", value: client.fitnessLevel)
                }
            }
            
            InfoCard(title: "CURRENT TRAINER", icon: "dumbbell.fill") {
                VStack(alignment: .leading, spacing: 12) {
                    if let trainer = client.currentTrainer {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.tmGold)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(trainer.prefix(1))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(trainer)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Personal Trainer")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("VIEW")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.tmGold)
                                    )
                            }
                        }
                    } else {
                        Text("No trainer assigned yet")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            InfoCard(title: "ACTIVITY", icon: "figure.run") {
                VStack(spacing: 12) {
                    ActivityStatRow(label: "Current Streak", value: "\(client.currentStreak) days", icon: "flame.fill", color: .orange)
                    ActivityStatRow(label: "Total Workouts", value: "\(client.workoutsCompleted)", icon: "checkmark.circle.fill", color: .green)
                    ActivityStatRow(label: "This Week", value: "\(client.workoutsThisWeek)", icon: "calendar", color: .blue)
                }
            }
        }
        .padding(20)
    }
}

// MARK: - Client Profile Goals Section
struct ClientProfileGoalsSection: View {
    let client: ClientProfile
    
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "FITNESS GOALS", icon: "target") {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(client.goals, id: \.self) { goal in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.tmGold)
                            Text(goal.rawValue)
                                .font(.body)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.05))
                        )
                    }
                }
            }
            
            InfoCard(title: "WEIGHT GOALS", icon: "scalemass.fill") {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Starting Weight")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(client.startingWeight) lbs")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.tmGold)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Target Weight")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(client.targetWeight) lbs")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.tmGold)
                        }
                    }
                    
                    // Progress Bar
                    let progress = CGFloat(client.startingWeight - client.currentWeight) / CGFloat(client.startingWeight - client.targetWeight)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current: \(client.currentWeight) lbs")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(Int(progress * 100))% to goal")
                                .font(.caption)
                                .foregroundColor(.tmGold)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.1))
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.tmGold)
                                    .frame(width: geometry.size.width * max(0, min(1, progress)))
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }
        }
        .padding(20)
    }
}

// MARK: - Client Profile Health Section
struct ClientProfileHealthSection: View {
    let client: ClientProfile
    
    var body: some View {
        VStack(spacing: 20) {
            // Warning Banner
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.shield.fill")
                    .foregroundColor(.tmGold)
                    .font(.title3)
                
                Text("This information is confidential and shared only with your trainer for safety.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.tmGold.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.tmGold, lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
            
            if !client.medicalConditions.isEmpty {
                InfoCard(title: "MEDICAL CONDITIONS", icon: "cross.case.fill") {
                    Text(client.medicalConditions)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
            }
            
            if !client.injuries.isEmpty {
                InfoCard(title: "INJURIES & LIMITATIONS", icon: "bandage.fill") {
                    Text(client.injuries)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
            }
            
            if !client.allergies.isEmpty {
                InfoCard(title: "ALLERGIES", icon: "allergens") {
                    Text(client.allergies)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
            }
            
            if !client.medications.isEmpty {
                InfoCard(title: "MEDICATIONS", icon: "pills.fill") {
                    Text(client.medications)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
            }
            
            if client.medicalConditions.isEmpty && client.injuries.isEmpty &&
               client.allergies.isEmpty && client.medications.isEmpty {
                InfoCard(title: "HEALTH STATUS", icon: "checkmark.shield.fill") {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        
                        Text("No health concerns reported")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            
            // Edit Health Info Button
            Button(action: {}) {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                    Text("UPDATE HEALTH INFORMATION")
                }
                .font(.system(size: 14, weight: .heavy))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.tmGold)
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Client Progress Section
struct ClientProgressSection: View {
    let client: ClientProfile
    
    var body: some View {
        VStack(spacing: 20) {
            InfoCard(title: "PROGRESS PHOTOS", icon: "photo.on.rectangle.angled") {
                if client.progressPhotoCount > 0 {
                    VStack(spacing: 16) {
                        Text("\(client.progressPhotoCount) Progress Photos")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.tmGold)
                        
                        // Sample photo grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(0..<min(6, client.progressPhotoCount), id: \.self) { index in
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
                                    
                                    Image(systemName: "photo.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Button(action: {}) {
                            Text("VIEW ALL PHOTOS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.tmGold)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No progress photos yet")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Upload photos to track your transformation")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                }
            }
            
            InfoCard(title: "MEASUREMENTS", icon: "ruler.fill") {
                VStack(spacing: 12) {
                    MeasurementRow(label: "Chest", value: client.measurements.chest, change: "+2")
                    MeasurementRow(label: "Waist", value: client.measurements.waist, change: "-3")
                    MeasurementRow(label: "Hips", value: client.measurements.hips, change: "-1")
                    MeasurementRow(label: "Arms", value: client.measurements.arms, change: "+1")
                }
            }
        }
        .padding(20)
    }
}

// MARK: - Supporting Views
struct ActivityStatRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
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

struct MeasurementRow: View {
    let label: String
    let value: Double
    let change: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
            Text("\(String(format: "%.1f", value)) in")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(change)
                .font(.caption)
                .foregroundColor(change.hasPrefix("+") ? .green : .red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
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
