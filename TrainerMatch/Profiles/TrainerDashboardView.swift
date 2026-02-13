//
//
//  TrainerDashboard.swift
//  TrainerMatch
//
//  Wrapper for trainer dashboard after login
//

import SwiftUI

struct TrainerDashboard: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let savedTrainer = authManager.currentTrainerProfile {
                // Convert SavedTrainerProfile to TrainerProfile for display
                let displayProfile = TrainerProfile(
                    id: savedTrainer.id,
                    userId: savedTrainer.id,
                    businessName: savedTrainer.businessName,
                    bio: savedTrainer.bio.isEmpty ? nil : savedTrainer.bio,
                    specialties: Array(savedTrainer.specialties),
                    certifications: Array(savedTrainer.certifications).map { $0.rawValue },
                    yearsOfExperience: savedTrainer.yearsOfExperience,
                    serviceTypes: Array(savedTrainer.serviceTypes),
                    location: TrainerLocation(
                        city: savedTrainer.city,
                        state: savedTrainer.state
                    ),
                    hourlyRate: savedTrainer.hourlyRate,
                    profileImageURL: nil,
                    websiteURL: nil,
                    instagramHandle: nil,
                    isVerified: false,
                    rating: 5.0,
                    totalReviews: 0
                )
                
                TrainerProfileMySpaceView(trainer: displayProfile)
                    .environmentObject(authManager)
            } else {
                // Fallback error view
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .font(.system(size: 60))
                        .foregroundColor(.tmGold)
                    
                    Text("Profile Not Found")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Button("Logout") {
                        authManager.logout()
                        dismiss()
                    }
                    .foregroundColor(.tmGold)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TrainerDashboard()
            .environmentObject(AuthManager.shared)
    }
}
