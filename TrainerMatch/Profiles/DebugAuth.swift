//
//  DebugAuth.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  DebugAuthView.swift
//  TrainerMatch
//
//  TEMPORARY DEBUG VIEW - Use to check what accounts exist
//  DELETE THIS FILE after testing!
//

import SwiftUI

struct DebugAuthView: View {
    @StateObject private var authManager = AuthManager.shared
    
    @State private var savedTrainers: [SavedTrainerProfile] = []
    @State private var savedClients: [SavedClientProfile] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Current Session")) {
                    Text("Authenticated: \(authManager.isAuthenticated ? "YES" : "NO")")
                    Text("Role: \(authManager.currentUserRole?.rawValue ?? "None")")
                    Text("Email: \(authManager.currentUserEmail ?? "None")")
                }
                
                Section(header: Text("Saved Trainers (\(savedTrainers.count))")) {
                    if savedTrainers.isEmpty {
                        Text("No trainers saved")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(savedTrainers) { trainer in
                            VStack(alignment: .leading) {
                                Text(trainer.fullName)
                                    .font(.headline)
                                Text(trainer.email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Password: \(trainer.password)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section(header: Text("Saved Clients (\(savedClients.count))")) {
                    if savedClients.isEmpty {
                        Text("No clients saved")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(savedClients) { client in
                            VStack(alignment: .leading) {
                                Text(client.fullName)
                                    .font(.headline)
                                Text(client.email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Password: \(client.password)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section(header: Text("Actions")) {
                    Button("Create Test Trainer Account") {
                        createTestTrainer()
                    }
                    
                    Button("Create Test Client Account") {
                        createTestClient()
                    }
                    
                    Button("Clear All Data", role: .destructive) {
                        clearAllData()
                    }
                    
                    Button("Refresh") {
                        loadData()
                    }
                }
            }
            .navigationTitle("Auth Debug")
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        let userDefaults = UserDefaults.standard
        
        if let data = userDefaults.data(forKey: "savedTrainers"),
           let trainers = try? JSONDecoder().decode([SavedTrainerProfile].self, from: data) {
            savedTrainers = trainers
        } else {
            savedTrainers = []
        }
        
        if let data = userDefaults.data(forKey: "savedClients"),
           let clients = try? JSONDecoder().decode([SavedClientProfile].self, from: data) {
            savedClients = clients
        } else {
            savedClients = []
        }
    }
    
    func createTestTrainer() {
        let success = authManager.registerTrainer(
            businessName: "Test Gym",
            firstName: "Test",
            lastName: "Trainer",
            email: "trainer@test.com",
            password: "test123",
            city: "Las Vegas",
            state: "NV",
            yearsOfExperience: "5",
            hourlyRate: "75",
            monthlyRate: "200",
            bio: "Test trainer bio",
            certifications: [.nasmCpt],
            schools: [.nasm],
            specialties: [.personalTraining],
            serviceTypes: [.inPerson]
        )
        
        print("Test trainer created: \(success)")
        loadData()
    }
    
    func createTestClient() {
        let success = authManager.registerClient(
            firstName: "Test",
            lastName: "Client",
            email: "client@test.com",
            password: "test123",
            city: "Las Vegas",
            state: "NV",
            birthDate: Date(),
            fitnessGoals: [.weightLoss],
            fitnessLevel: "Beginner",
            targetWeight: "150",
            medicalConditions: "None",
            injuries: "None",
            allergies: "None",
            medications: "None"
        )
        
        print("Test client created: \(success)")
        loadData()
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "savedTrainers")
        UserDefaults.standard.removeObject(forKey: "savedClients")
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
        UserDefaults.standard.removeObject(forKey: "currentUserRole")
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        
        authManager.logout()
        loadData()
    }
}

#Preview {
    DebugAuthView()
}
