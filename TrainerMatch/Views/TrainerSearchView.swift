//
//  TrainerSearchView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct TrainerSearchView: View {
    @State private var city = ""
    @State private var selectedSpecialty: TrainerSpecialty?
    @State private var selectedServiceType: ServiceType = .inPerson
    @State private var selectedGender: String = "Any"
    @State private var showingResults = false
    
    var body: some View {
        ZStack {
            // Background with gold gradient (matching website)
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.82, blue: 0.45),
                    Color(red: 0.92, green: 0.78, blue: 0.38)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Card Container
                    VStack(spacing: 24) {
                        // Logo - Large with gold shadow
                        VStack(spacing: 20) {
                            TrainerMatchLogo(size: .large)
                                .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        }
                        
                        // Title
                        VStack(spacing: 8) {
                            Text("It's Match Time!")
                                .font(.system(size: 42, weight: .bold))
                                .italic()
                                .foregroundColor(.black)
                            
                            Text("Tweak the filters to match with trainers who fit your goals.")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Search Form
                        VStack(spacing: 16) {
                            // City Input
                            TextField("Enter City", text: $city)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            
                            // Specialty Picker
                            Menu {
                                ForEach(TrainerSpecialty.allCases.prefix(15), id: \.self) { specialty in
                                    Button(specialty.rawValue) {
                                        selectedSpecialty = specialty
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedSpecialty?.rawValue ?? "Specialty")
                                        .foregroundColor(selectedSpecialty == nil ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Workout Format Picker
                            Menu {
                                Button("In-Person") {
                                    selectedServiceType = .inPerson
                                }
                                Button("Online") {
                                    selectedServiceType = .online
                                }
                                Button("Both") {
                                    selectedServiceType = .both
                                }
                            } label: {
                                HStack {
                                    Text(selectedServiceType.rawValue)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Gender Picker
                            Menu {
                                Button("Any") { selectedGender = "Any" }
                                Button("Male") { selectedGender = "Male" }
                                Button("Female") { selectedGender = "Female" }
                            } label: {
                                HStack {
                                    Text(selectedGender)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Show Matches Button
                            Button(action: {
                                showingResults = true
                            }) {
                                Text("SHOW MATCHES")
                                    .font(.system(size: 15, weight: .heavy))
                                    .tracking(0.5)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(
                                        RoundedRectangle(cornerRadius: 27)
                                            .fill(Color.black)
                                    )
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 60)
                }
            }
        }
        .navigationTitle("Find Trainers")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingResults) {
            TrainerResultsView(
                city: city,
                specialty: selectedSpecialty,
                serviceType: selectedServiceType,
                gender: selectedGender
            )
        }
    }
}

// MARK: - Trainer Results View
struct TrainerResultsView: View {
    @Environment(\.dismiss) var dismiss
    let city: String
    let specialty: TrainerSpecialty?
    let serviceType: ServiceType
    let gender: String
    
    // Sample trainer results with photos
    let trainers = [
        (name: "Cesarina Jones", specialty: "Pilates", serviceType: "In-Person", gender: "Female", image: "figure.yoga"),
        (name: "Jayke Fizer", specialty: "Bodybuilding", serviceType: "In-Person, Online", gender: "Male", image: "figure.strengthtraining.traditional"),
        (name: "Mario Kutz", specialty: "Pilates", serviceType: "In-Person", gender: "Male", image: "figure.mind.and.body"),
        (name: "Jessica Moore", specialty: "CXWORX", serviceType: "In-Person", gender: "Female", image: "figure.core.training"),
        (name: "Sarah Chen", specialty: "Yoga", serviceType: "Online", gender: "Female", image: "figure.flexibility"),
        (name: "Mike Rodriguez", specialty: "CrossFit", serviceType: "In-Person", gender: "Male", image: "figure.highintensity.intervaltraining")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with logo
                    VStack(spacing: 20) {
                        TrainerMatchLogo(size: .large)
                            .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Text("Match Results")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 20)
                    
                    // Trainer Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(trainers.indices, id: \.self) { index in
                            NavigationLink(destination: TrainerDetailView(trainer: trainers[index])) {
                                TrainerProfileCard(trainer: trainers[index])
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

// MARK: - Trainer Profile Card (Website Style)
struct TrainerProfileCard: View {
    let trainer: (name: String, specialty: String, serviceType: String, gender: String, image: String)
    
    var body: some View {
        VStack(spacing: 0) {
            // Image Section
            ZStack(alignment: .topTrailing) {
                // Profile Image
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                    
                    Image(systemName: trainer.image)
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                // Service Type Badges (Top Right)
                VStack(spacing: 6) {
                    ForEach(Array(serviceTypeBadges.enumerated()), id: \.offset) { index, badge in
                        ServiceBadge(text: badge.text, color: badge.color)
                    }
                }
                .padding(10)
            }
            
            // Info Section with Gold Background
            VStack(spacing: 8) {
                Text(trainer.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text(trainer.specialty.uppercased())
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.7))
                    .tracking(0.5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.88, green: 0.73, blue: 0.25),
                        Color(red: 0.85, green: 0.68, blue: 0.20)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var serviceTypeBadges: [(text: String, color: Color)] {
        var badges: [(String, Color)] = []
        
        // Check for featured
        if Int.random(in: 0...2) == 0 {
            badges.append(("FEATURED", .red))
        }
        
        // Add service type badges
        if trainer.serviceType.contains("In-Person") {
            badges.append(("IN-PERSON", .blue))
        }
        if trainer.serviceType.contains("Online") {
            badges.append(("ONLINE", .purple))
        }
        
        // Add gender badge
        badges.append((trainer.gender.uppercased(), .gray))
        
        return badges
    }
}

// MARK: - Service Badge
struct ServiceBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .heavy))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

#Preview {
    NavigationView {
        TrainerSearchView()
    }
}
