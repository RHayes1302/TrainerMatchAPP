//
//  LocationBasedOnSearch.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI
import CoreLocation

struct LocationBasedSearchView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchRadius: Double = 25 // miles
    @State private var selectedSpecialty: TrainerSpecialty?
    @State private var selectedGender: String = "Any"
    @State private var showingResults = false
    @State private var useCurrentLocation = true
    @State private var manualCity = ""
    @State private var manualState = ""
    
    // Fixed to in-person only
    private let serviceType: ServiceType = .inPerson
    
    var body: some View {
        ZStack {
            // Gold gradient background
            Color.tmGoldGradient()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Main Card
                    VStack(spacing: 24) {
                        // Logo
                        VStack(spacing: 20) {
                            TrainerMatchLogo(size: .large)
                                .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        }
                        
                        // Title
                        VStack(spacing: 8) {
                            Text("Find In-Person Trainers")
                                .font(.system(size: 36, weight: .bold))
                                .italic()
                                .foregroundColor(.black)
                            
                            Text("Search for local trainers offering in-person training")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Location Toggle
                        VStack(spacing: 16) {
                            Toggle(isOn: $useCurrentLocation) {
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.tmGold)
                                    Text("Use My Current Location")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                            }
                            .tint(.tmGold)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(12)
                            
                            if useCurrentLocation {
                                // Current Location Display
                                if locationManager.isLoading {
                                    HStack {
                                        ProgressView()
                                            .tint(.tmGold)
                                        Text("Getting your location...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                } else if !locationManager.city.isEmpty {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.tmGold)
                                        Text("\(locationManager.city), \(locationManager.state)")
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                } else {
                                    Button(action: {
                                        locationManager.requestLocation()
                                    }) {
                                        HStack {
                                            Image(systemName: "location.circle.fill")
                                            Text("Get My Location")
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.tmGold)
                                        .cornerRadius(12)
                                    }
                                }
                                
                                if let error = locationManager.errorMessage {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            } else {
                                // Manual Location Entry
                                VStack(spacing: 12) {
                                    TextField("Enter City", text: $manualCity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                    
                                    TextField("Enter State", text: $manualState)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                            }
                            
                            // Search Radius Slider
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Search Radius: \(Int(searchRadius)) miles")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Slider(value: $searchRadius, in: 5...100, step: 5)
                                    .tint(.tmGold)
                                
                                HStack {
                                    Text("5 mi")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("100 mi")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(12)
                            
                            // Specialty Filter
                            Menu {
                                Button("Any Specialty") {
                                    selectedSpecialty = nil
                                }
                                Divider()
                                ForEach(TrainerSpecialty.allCases.prefix(15), id: \.self) { specialty in
                                    Button(specialty.rawValue) {
                                        selectedSpecialty = specialty
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.tmGold)
                                    Text(selectedSpecialty?.rawValue ?? "Any Specialty")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            
                            // In-Person Only Badge (not a filter, just informational)
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .font(.caption)
                                    .foregroundColor(.tmGold)
                                Text("In-Person Training Only")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.tmGold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.tmGold.opacity(0.2))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.tmGold, lineWidth: 1)
                                    )
                            )
                            
                            // Gender Filter
                            Menu {
                                Button("Any Gender") {
                                    selectedGender = "Any"
                                }
                                Button("Male") {
                                    selectedGender = "Male"
                                }
                                Button("Female") {
                                    selectedGender = "Female"
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.tmGold)
                                    Text(selectedGender == "Any" ? "Any Gender" : selectedGender)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            
                            // Search Button
                            Button(action: {
                                showingResults = true
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text("FIND TRAINERS")
                                }
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
                            .disabled(!canSearch)
                            .opacity(canSearch ? 1.0 : 0.5)
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
            LocationBasedResultsView(
                userLocation: useCurrentLocation ? locationManager.location?.coordinate : nil,
                city: useCurrentLocation ? locationManager.city : manualCity,
                state: useCurrentLocation ? locationManager.state : manualState,
                radius: searchRadius,
                specialty: selectedSpecialty,
                serviceType: serviceType,
                gender: selectedGender
            )
        }
        .onAppear {
            if useCurrentLocation {
                locationManager.requestLocation()
            }
        }
    }
    
    private var canSearch: Bool {
        if useCurrentLocation {
            return !locationManager.city.isEmpty
        } else {
            return !manualCity.isEmpty && !manualState.isEmpty
        }
    }
}

// MARK: - Location Based Results View
struct LocationBasedResultsView: View {
    @Environment(\.dismiss) var dismiss
    let userLocation: CLLocationCoordinate2D?
    let city: String
    let state: String
    let radius: Double
    let specialty: TrainerSpecialty?
    let serviceType: ServiceType
    let gender: String
    
    // Sample trainers with locations and gender
    let allTrainers = [
        (name: "Cesarina Jones", specialty: "Pilates", serviceType: "In-Person", gender: "Female", lat: 36.1699, lon: -115.1398, distance: 2.3),
        (name: "Mario Kutz", specialty: "Pilates", serviceType: "In-Person", gender: "Male", lat: 36.1147, lon: -115.1728, distance: 5.8),
        (name: "Jayke Fizer", specialty: "Bodybuilding", serviceType: "In-Person", gender: "Male", lat: 36.2088, lon: -115.2374, distance: 8.1),
        (name: "Jessica Moore", specialty: "HIIT", serviceType: "In-Person", gender: "Female", lat: 36.0836, lon: -115.0504, distance: 12.4),
        (name: "Sarah Chen", specialty: "Yoga", serviceType: "In-Person", gender: "Female", lat: 36.1215, lon: -115.1739, distance: 4.2),
        (name: "Mike Rodriguez", specialty: "CrossFit", serviceType: "In-Person", gender: "Male", lat: 36.1147, lon: -115.1728, distance: 6.5),
        (name: "Emily Davis", specialty: "Zumba", serviceType: "In-Person", gender: "Female", lat: 36.1500, lon: -115.1400, distance: 7.3),
        (name: "Tom Wilson", specialty: "Strength Training", serviceType: "In-Person", gender: "Male", lat: 36.1800, lon: -115.1600, distance: 9.8)
    ]
    
    var filteredTrainers: [(name: String, specialty: String, serviceType: String, gender: String, lat: Double, lon: Double, distance: Double)] {
        allTrainers.filter { trainer in
            // Filter by radius
            guard trainer.distance <= radius else { return false }
            
            // Filter by gender if specified
            if gender != "Any" && trainer.gender != gender {
                return false
            }
            
            // Filter by specialty if specified
            if let specialty = specialty, trainer.specialty != specialty.rawValue {
                return false
            }
            
            // Filter by service type
            if !trainer.serviceType.contains(serviceType.rawValue) {
                return false
            }
            
            return true
        }.sorted { $0.distance < $1.distance }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        TrainerMatchLogo(size: .medium)
                            .shadow(color: .tmGold.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text("Trainers Near You")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.tmGold)
                            Text("\(city), \(state)")
                                .font(.subheadline)
                            
                            Text("•")
                                .foregroundColor(.gray)
                            
                            Text("Within \(Int(radius)) miles")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Results Count
                    Text("\(filteredTrainers.count) trainers found")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Active Filters Display
                    HStack(spacing: 8) {
                        Text("Filters:")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        // Always show In-Person badge
                        FilterBadge(text: "In-Person")
                        
                        if let specialty = specialty {
                            FilterBadge(text: specialty.rawValue)
                        }
                        
                        if gender != "Any" {
                            FilterBadge(text: gender)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Trainer List
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTrainers.indices, id: \.self) { index in
                            LocationTrainerCard(trainer: filteredTrainers[index])
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
                        .foregroundColor(.tmGold)
                    }
                }
            }
    }
}

// MARK: - Location Trainer Card
struct LocationTrainerCard: View {
    let trainer: (name: String, specialty: String, serviceType: String, gender: String, lat: Double, lon: Double, distance: Double)
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Circle
            Circle()
                .fill(Color.tmGoldGradient())
                .frame(width: 60, height: 60)
                .overlay(
                    Text(trainer.name.prefix(1))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                )
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(trainer.name)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Text(trainer.specialty)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Gender Badge
                    Text(trainer.gender)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.tmGold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.tmGold.opacity(0.2))
                        )
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.tmGold)
                    Text(String(format: "%.1f miles away", trainer.distance))
                        .font(.caption)
                        .foregroundColor(.tmGold)
                }
            }
            
            Spacer()
            
            // View Button
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
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Filter Badge
struct FilterBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.tmGold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.tmGold.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(Color.tmGold.opacity(0.5), lineWidth: 1)
                    )
            )
    }
}

#Preview {
    NavigationView {
        LocationBasedSearchView()
    }
}
