//
//  TrainerTempLocation.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI
import CoreLocation

struct TrainerTempLocationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationManager = LocationManager()
    
    @State private var useCurrentLocation = true
    @State private var city = ""
    @State private var state = ""
    @State private var startDate = Date()
    @State private var hasEndDate = false
    @State private var endDate = Date().addingTimeInterval(7 * 24 * 60 * 60) // 1 week from now
    @State private var notes = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            TrainerMatchLogo(size: .medium)
                                .shadow(color: .tmGold.opacity(0.3), radius: 15, x: 0, y: 5)
                            
                            Text("Set Training Location")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Update your location when traveling to train clients in different areas")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Form Card
                        VStack(spacing: 20) {
                            // Location Toggle
                            VStack(alignment: .leading, spacing: 12) {
                                Text("LOCATION")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.tmGold)
                                
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
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                            
                            if useCurrentLocation {
                                // Current Location Display
                                VStack(spacing: 12) {
                                    if locationManager.isLoading {
                                        HStack {
                                            ProgressView()
                                                .tint(.tmGold)
                                            Text("Getting your location...")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        .padding()
                                    } else if !locationManager.city.isEmpty {
                                        HStack {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundColor(.tmGold)
                                            VStack(alignment: .leading) {
                                                Text(locationManager.city)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                Text(locationManager.state)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white.opacity(0.7))
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.05))
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
                                            .foregroundColor(.black)
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
                                    }
                                }
                            } else {
                                // Manual Location Entry
                                VStack(spacing: 12) {
                                    LocationInputField(label: "City *", text: $city, placeholder: "Las Vegas")
                                    LocationInputField(label: "State *", text: $state, placeholder: "NV")
                                }
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                            
                            // Duration
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DURATION")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.tmGold)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Start Date")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    DatePicker("", selection: $startDate, displayedComponents: [.date])
                                        .datePickerStyle(.compact)
                                        .colorScheme(.dark)
                                        .labelsHidden()
                                        .padding()
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(8)
                                }
                                
                                Toggle(isOn: $hasEndDate) {
                                    Text("Set End Date")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .tint(.tmGold)
                                
                                if hasEndDate {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("End Date")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        DatePicker("", selection: $endDate, in: startDate..., displayedComponents: [.date])
                                            .datePickerStyle(.compact)
                                            .colorScheme(.dark)
                                            .labelsHidden()
                                            .padding()
                                            .background(Color.white.opacity(0.05))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes (Optional)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                TextEditor(text: $notes)
                                    .frame(height: 80)
                                    .padding(8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                                
                                Text("e.g., Training clients in this area, Available for new clients")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            // Save Button
                            Button(action: {
                                saveLocation()
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("SET LOCATION")
                                }
                                .font(.system(size: 14, weight: .heavy))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(isFormValid ? Color.tmGold : Color.gray.opacity(0.5))
                                )
                            }
                            .disabled(!isFormValid)
                            .padding(.top, 8)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.tmGold)
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("Location Updated!", isPresented: $showingSuccess) {
                Button("Done", role: .cancel) {
                    dismiss()
                }
            } message: {
                let location = useCurrentLocation ? "\(locationManager.city), \(locationManager.state)" : "\(city), \(state)"
                Text("Your training location has been set to \(location)")
            }
            .onAppear {
                if useCurrentLocation {
                    locationManager.requestLocation()
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        if useCurrentLocation {
            return !locationManager.city.isEmpty
        } else {
            return !city.isEmpty && !state.isEmpty
        }
    }
    
    private func saveLocation() {
        // Here you would save to your backend/database
        // For now, just show success
        showingSuccess = true
    }
}

// MARK: - Location Input Field
struct LocationInputField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }
}

#Preview {
    TrainerTempLocationView()
}
