//
//  ClientDetailView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

//import SwiftUI
//
//struct ClientDetailView: View {
//    let client: Client
//    @ObservedObject var trainerVM: TrainerViewModel
//    
//    @State private var selectedTab = 0
//    @State private var showingAddWorkout = false
//    @State private var showingAddProgress = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Client Header
//                ClientHeaderView(client: client)
//                
//                // Tab Selector
//                Picker("", selection: $selectedTab) {
//                    Text("Overview").tag(0)
//                    Text("Workouts").tag(1)
//                    Text("Progress").tag(2)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal)
//                
//                // Tab Content
//                switch selectedTab {
//                case 0:
//                    OverviewTabView(client: client, trainerVM: trainerVM)
//                case 1:
//                    WorkoutsTabView(client: client, trainerVM: trainerVM, showingAddWorkout: $showingAddWorkout)
//                case 2:
//                    ProgressTabView(client: client, trainerVM: trainerVM, showingAddProgress: $showingAddProgress)
//                default:
//                    EmptyView()
//                }
//            }
//            .padding(.bottom, 20)
//        }
//        .navigationTitle(client.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $showingAddWorkout) {
//            AddWorkoutView(client: client, trainerVM: trainerVM)
//        }
//        .sheet(isPresented: $showingAddProgress) {
//            AddProgressEntryView(client: client, trainerVM: trainerVM)
//        }
//    }
//}
//
//// MARK: - Client Header
//struct ClientHeaderView: View {
//    let client: Client
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Profile Image
//            Circle()
//                .fill(LinearGradient(
//                    colors: [.blue, .purple],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                ))
//                .frame(width: 80, height: 80)
//                .overlay(
//                    Text(client.name.prefix(1))
//                        .font(.system(size: 36, weight: .bold))
//                        .foregroundColor(.white)
//                )
//            
//            // Client Info
//            Text(client.name)
//                .font(.title2)
//                .fontWeight(.bold)
//            
//            Text(client.email)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            
//            if let phone = client.phoneNumber {
//                Text(phone)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            
//            // Quick Stats
//            HStack(spacing: 30) {
//                VStack(spacing: 4) {
//                    Text("\(daysActive)")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                    Text("Days Active")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                
//                if let current = client.currentWeight, let goal = client.goalWeight {
//                    VStack(spacing: 4) {
//                        Text("\(Int(current - goal)) kg")
//                            .font(.title3)
//                            .fontWeight(.bold)
//                            .foregroundColor(current > goal ? .orange : .green)
//                        Text("To Goal")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding()
//            .background(Color(.systemGray6))
//            .cornerRadius(12)
//        }
//        .padding()
//    }
//    
//    private var daysActive: Int {
//        let calendar = Calendar.current
//        let days = calendar.dateComponents([.day], from: client.dateJoined, to: Date()).day ?? 0
//        return days
//    }
//}
//
//// MARK: - Overview Tab
//struct OverviewTabView: View {
//    let client: Client
//    @ObservedObject var trainerVM: TrainerViewModel
//    
//    var stats: ClientStats {
//        trainerVM.getClientStats(for: client)
//    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Health Metrics Cards
//            VStack(spacing: 12) {
//                Text("Today's Activity")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//                
//                StepCardView(steps: client.dailySteps)
//                    .padding(.horizontal)
//                
//                DistanceCardView(distance: client.dailyDistance / 1000)
//                    .padding(.horizontal)
//                
//                ActivityStatusCard(
//                    activityStatus: client.activityStatus,
//                    authStatus: "Synced",
//                    isAuthorized: true
//                )
//                .padding(.horizontal)
//            }
//            
//            // Workout Stats
//            VStack(spacing: 12) {
//                Text("Workout Statistics")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//                
//                HStack(spacing: 12) {
//                    WorkoutStatCard(
//                        title: "Total",
//                        value: "\(stats.totalWorkouts)",
//                        icon: "list.bullet",
//                        color: .blue
//                    )
//                    
//                    WorkoutStatCard(
//                        title: "Completed",
//                        value: "\(stats.completedWorkouts)",
//                        icon: "checkmark.circle.fill",
//                        color: .green
//                    )
//                }
//                .padding(.horizontal)
//                
//                HStack(spacing: 12) {
//                    WorkoutStatCard(
//                        title: "Active",
//                        value: "\(stats.activeWorkouts)",
//                        icon: "flame.fill",
//                        color: .orange
//                    )
//                    
//                    WorkoutStatCard(
//                        title: "Completion",
//                        value: "\(Int(stats.completionRate))%",
//                        icon: "chart.bar.fill",
//                        color: .purple
//                    )
//                }
//                .padding(.horizontal)
//            }
//            
//            // Trainer Notes
//            if let notes = client.trainerNotes {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Trainer Notes")
//                        .font(.headline)
//                    
//                    Text(notes)
//                        .font(.body)
//                        .foregroundColor(.gray)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal)
//            }
//            
//            // Fitness Goals
//            if !client.fitnessGoals.isEmpty {
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Fitness Goals")
//                        .font(.headline)
//                        .padding(.horizontal)
//                    
//                    VStack(spacing: 8) {
//                        ForEach(client.fitnessGoals, id: \.self) { goal in
//                            GoalTag(goal: goal)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            
//            // Client Source
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Image(systemName: "person.crop.circle.badge.checkmark")
//                        .foregroundColor(.blue)
//                    if let foundVia = client.foundVia {
//                        Text("Found via: \(foundVia)")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    if let serviceType = client.preferredServiceType {
//                        Text("•")
//                            .foregroundColor(.gray)
//                        Text(serviceType.rawValue)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
//// MARK: - Workout Stat Card
//struct WorkoutStatCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundColor(color)
//            
//            Text(value)
//                .font(.title)
//                .fontWeight(.bold)
//            
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(color.opacity(0.1))
//        .cornerRadius(12)
//    }
//}
//
//// MARK: - Workouts Tab
//struct WorkoutsTabView: View {
//    let client: Client
//    @ObservedObject var trainerVM: TrainerViewModel
//    @Binding var showingAddWorkout: Bool
//    
//    var activeWorkouts: [Workout] {
//        trainerVM.getActiveWorkouts(for: client)
//    }
//    
//    var completedWorkouts: [Workout] {
//        trainerVM.getCompletedWorkouts(for: client)
//    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Add Workout Button
//            Button(action: { showingAddWorkout = true }) {
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                    Text("Assign New Workout")
//                }
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            
//            // Active Workouts
//            if !activeWorkouts.isEmpty {
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Active Workouts")
//                        .font(.headline)
//                        .padding(.horizontal)
//                    
//                    ForEach(activeWorkouts) { workout in
//                        WorkoutCardView(workout: workout, trainerVM: trainerVM)
//                            .padding(.horizontal)
//                    }
//                }
//            }
//            
//            // Completed Workouts
//            if !completedWorkouts.isEmpty {
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Completed Workouts")
//                        .font(.headline)
//                        .padding(.horizontal)
//                    
//                    ForEach(completedWorkouts) { workout in
//                        WorkoutCardView(workout: workout, trainerVM: trainerVM)
//                            .padding(.horizontal)
//                    }
//                }
//            }
//            
//            if activeWorkouts.isEmpty && completedWorkouts.isEmpty {
//                VStack(spacing: 12) {
//                    Image(systemName: "dumbbell")
//                        .font(.system(size: 60))
//                        .foregroundColor(.gray.opacity(0.5))
//                    
//                    Text("No workouts assigned yet")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                    
//                    Text("Tap the button above to assign the first workout")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                .padding(.top, 40)
//            }
//        }
//    }
//}
//
//// MARK: - Workout Card
//struct WorkoutCardView: View {
//    let workout: Workout
//    @ObservedObject var trainerVM: TrainerViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(workout.name)
//                        .font(.headline)
//                    
//                    if let description = workout.description {
//                        Text(description)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Spacer()
//                
//                if workout.isCompleted {
//                    Image(systemName: "checkmark.circle.fill")
//                        .foregroundColor(.green)
//                        .font(.title2)
//                }
//            }
//            
//            // Workout Details
//            HStack(spacing: 16) {
//                Label("\(workout.exercises.count) exercises", systemImage: "list.bullet")
//                    .font(.caption)
//                
//                if let duration = workout.estimatedDuration {
//                    Label("\(duration) min", systemImage: "clock")
//                        .font(.caption)
//                }
//                
//                Label(workout.difficulty.rawValue, systemImage: "chart.bar")
//                    .font(.caption)
//            }
//            .foregroundColor(.gray)
//            
//            // Dates
//            HStack {
//                Text("Assigned: \(workout.assignedDate, style: .date)")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                
//                Spacer()
//                
//                if let dueDate = workout.dueDate {
//                    Text("Due: \(dueDate, style: .date)")
//                        .font(.caption2)
//                        .foregroundColor(workout.isCompleted ? .green : (dueDate < Date() ? .red : .orange))
//                }
//            }
//            
//            if !workout.isCompleted {
//                Button(action: {
//                    trainerVM.markWorkoutComplete(workout)
//                }) {
//                    Text("Mark as Complete")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.blue)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 8)
//                        .background(Color.blue.opacity(0.1))
//                        .cornerRadius(8)
//                }
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//    }
//}
//
//// MARK: - Progress Tab
//struct ProgressTabView: View {
//    let client: Client
//    @ObservedObject var trainerVM: TrainerViewModel
//    @Binding var showingAddProgress: Bool
//    @State private var showingPhotoGallery = false
//    
//    var progressEntries: [ProgressEntry] {
//        trainerVM.getProgressEntries(for: client)
//    }
//    
//    var entriesWithPhotos: Int {
//        progressEntries.filter { $0.photoURLs != nil && !$0.photoURLs!.isEmpty }.count
//    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Action Buttons
//            HStack(spacing: 12) {
//                // Add Progress Button
//                Button(action: { showingAddProgress = true }) {
//                    HStack {
//                        Image(systemName: "plus.circle.fill")
//                        Text("Add Entry")
//                    }
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.tmBlack)
//                    )
//                }
//                
//                // View Photos Button
//                Button(action: { showingPhotoGallery = true }) {
//                    HStack {
//                        Image(systemName: "photo.on.rectangle.angled")
//                        Text("Photos")
//                        if entriesWithPhotos > 0 {
//                            Text("(\(entriesWithPhotos))")
//                                .font(.caption)
//                        }
//                    }
//                    .font(.headline)
//                    .foregroundColor(.tmBlack)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color.tmGold)
//                    )
//                }
//            }
//            .padding(.horizontal)
//            
//            // Progress Entries
//            if !progressEntries.isEmpty {
//                ForEach(progressEntries) { entry in
//                    ProgressEntryCardView(entry: entry)
//                        .padding(.horizontal)
//                }
//            } else {
//                VStack(spacing: 12) {
//                    Image(systemName: "chart.line.uptrend.xyaxis")
//                        .font(.system(size: 60))
//                        .foregroundColor(.gray.opacity(0.5))
//                    
//                    Text("No progress entries yet")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                    
//                    Text("Track weight, measurements, and photos")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                .padding(.top, 40)
//            }
//        }
//        .sheet(isPresented: $showingPhotoGallery) {
//            NavigationView {
//                ProgressPhotoGalleryView(client: client, progressEntries: progressEntries)
//            }
//        }
//    }
//}
//
//// MARK: - Progress Entry Card
//struct ProgressEntryCardView: View {
//    let entry: ProgressEntry
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text(entry.date, style: .date)
//                    .font(.headline)
//                
//                Spacer()
//                
//                Image(systemName: "calendar")
//                    .foregroundColor(.gray)
//            }
//            
//            if let weight = entry.weight {
//                HStack {
//                    Image(systemName: "scalemass")
//                        .foregroundColor(.blue)
//                    Text("Weight: \(String(format: "%.1f kg", weight))")
//                        .font(.subheadline)
//                }
//            }
//            
//            if let bodyFat = entry.bodyFat {
//                HStack {
//                    Image(systemName: "percent")
//                        .foregroundColor(.orange)
//                    Text("Body Fat: \(String(format: "%.1f%%", bodyFat))")
//                        .font(.subheadline)
//                }
//            }
//            
//            if let measurements = entry.measurements {
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("Measurements")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    
//                    HStack(spacing: 12) {
//                        if let chest = measurements.chest {
//                            MeasurementTag(label: "Chest", value: chest)
//                        }
//                        if let waist = measurements.waist {
//                            MeasurementTag(label: "Waist", value: waist)
//                        }
//                        if let hips = measurements.hips {
//                            MeasurementTag(label: "Hips", value: hips)
//                        }
//                    }
//                }
//            }
//            
//            if let notes = entry.notes {
//                Text(notes)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding(8)
//                    .background(Color(.systemGray5))
//                    .cornerRadius(6)
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//    }
//}
//
//// MARK: - Measurement Tag
//struct MeasurementTag: View {
//    let label: String
//    let value: Double
//    
//    var body: some View {
//        VStack(spacing: 2) {
//            Text("\(Int(value))")
//                .font(.caption)
//                .fontWeight(.semibold)
//            Text(label)
//                .font(.caption2)
//                .foregroundColor(.gray)
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//        .background(Color(.systemGray5))
//        .cornerRadius(6)
//    }
//}
//
//// MARK: - Goal Tag
//struct GoalTag: View {
//    let goal: FitnessGoal
//    
//    var body: some View {
//        Text(goal.rawValue)
//            .font(.caption)
//            .padding(.horizontal, 12)
//            .padding(.vertical, 6)
//            .background(Color.green.opacity(0.1))
//            .foregroundColor(.green)
//            .cornerRadius(16)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    NavigationView {
//        ClientDetailView(
//            client: Client.sampleClients[0],
//            trainerVM: TrainerViewModel()
//        )
//    }
//}
