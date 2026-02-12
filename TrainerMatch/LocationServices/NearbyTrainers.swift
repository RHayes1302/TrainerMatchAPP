//
//  NearbyTrainers.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI
import CoreLocation

struct NearbyTrainersView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationManager = LocationManager()
    @State private var isSearching = true
    
    // Sample IN-PERSON ONLY trainers - in production, fetch from backend filtered by serviceType = .inPerson
    let nearbyTrainers = [
        (name: "Cesarina Jones", specialty: "Pilates", serviceType: "In-Person", distance: 2.3, rating: 4.9, image: "figure.yoga"),
        (name: "Mario Kutz", specialty: "Pilates", serviceType: "In-Person", distance: 3.1, rating: 4.8, image: "figure.mind.and.body"),
        (name: "Jayke Fizer", specialty: "Bodybuilding", serviceType: "In-Person", distance: 5.8, rating: 4.7, image: "figure.strengthtraining.traditional"),
        (name: "Mike Rodriguez", specialty: "CrossFit", serviceType: "In-Person", distance: 6.5, rating: 4.9, image: "figure.highintensity.intervaltraining"),
        (name: "Jessica Moore", specialty: "HIIT", serviceType: "In-Person", distance: 8.1, rating: 4.8, image: "figure.core.training"),
        (name: "Alex Thompson", specialty: "Strength Training", serviceType: "In-Person", distance: 12.4, rating: 4.9, image: "figure.strengthtraining.traditional"),
        (name: "Emily Davis", specialty: "Yoga", serviceType: "In-Person", distance: 15.7, rating: 5.0, image: "figure.yoga"),
        (name: "Chris Martinez", specialty: "Boxing", serviceType: "In-Person", distance: 18.2, rating: 4.8, image: "figure.boxing"),
        (name: "Nicole Brown", specialty: "Zumba", serviceType: "In-Person", distance: 22.5, rating: 4.9, image: "figure.dance"),
        (name: "David Wilson", specialty: "Running", serviceType: "In-Person", distance: 28.3, rating: 4.7, image: "figure.run"),
        (name: "Rachel Green", specialty: "Spin", serviceType: "In-Person", distance: 35.6, rating: 4.8, image: "figure.indoor.cycle"),
        (name: "Tom Anderson", specialty: "Boot Camp", serviceType: "In-Person", distance: 42.1, rating: 4.9, image: "figure.outdoor.cycle"),
        (name: "Lisa White", specialty: "Nutrition", serviceType: "In-Person", distance: 47.8, rating: 5.0, image: "figure.core.training")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if isSearching {
                    // Loading State
                    VStack(spacing: 24) {
                        TrainerMatchLogo(size: .large)
                            .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(.tmGold)
                                .scaleEffect(1.5)
                            
                            Text("Finding in-person trainers...")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if !locationManager.city.isEmpty {
                                Text("\(locationManager.city), \(locationManager.state)")
                                    .font(.subheadline)
                                    .foregroundColor(.tmGold)
                            }
                        }
                        .padding(.top, 20)
                    }
                } else {
                    // Results
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            VStack(spacing: 16) {
                                TrainerMatchLogo(size: .medium)
                                    .shadow(color: .tmGold.opacity(0.3), radius: 15, x: 0, y: 5)
                                
                                Text("In-Person Trainers")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                if !locationManager.city.isEmpty {
                                    HStack(spacing: 8) {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.tmGold)
                                        Text("\(locationManager.city), \(locationManager.state)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        
                                        Text("•")
                                            .foregroundColor(.white.opacity(0.5))
                                        
                                        Text("\(nearbyTrainers.count) available")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                
                                // In-Person Badge
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
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.tmGold.opacity(0.2))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.tmGold, lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.top, 20)
                            
                            // Quick Stats
                            HStack(spacing: 12) {
                                QuickStatCard(icon: "person.2.fill", label: "In-Person", color: .tmGold)
                                QuickStatCard(icon: "mappin.circle.fill", label: "Within 50 mi", color: .tmGold)
                                QuickStatCard(icon: "star.fill", label: "Top Rated", color: .tmGold)
                            }
                            .padding(.horizontal)
                            
                            // Trainer Cards
                            LazyVStack(spacing: 16) {
                                ForEach(nearbyTrainers.indices, id: \.self) { index in
                                    NearbyTrainerCard(trainer: nearbyTrainers[index])
                                }
                            }
                            .padding(.horizontal)
                            
                            // Advanced Search Button
                            NavigationLink(destination: LocationBasedSearchView()) {
                                HStack {
                                    Image(systemName: "slider.horizontal.3")
                                    Text("ADVANCED SEARCH")
                                }
                                .font(.system(size: 14, weight: .heavy))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.tmGold)
                                )
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
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
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            locationManager.requestLocation()
            // Simulate search delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isSearching = false
                }
            }
        }
    }
}

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// MARK: - Nearby Trainer Card
struct NearbyTrainerCard: View {
    let trainer: (name: String, specialty: String, serviceType: String, distance: Double, rating: Double, image: String)
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                
                Image(systemName: trainer.image)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(trainer.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(trainer.specialty)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: 12) {
                    // Distance
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.tmGold)
                        Text(String(format: "%.1f mi", trainer.distance))
                            .font(.caption)
                            .foregroundColor(.tmGold)
                    }
                    
                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.tmGold)
                        Text(String(format: "%.1f", trainer.rating))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Spacer()
            
            // View Button
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.tmGold)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    NearbyTrainersView()
}
