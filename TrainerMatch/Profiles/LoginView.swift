
//
//  LoginView.swift (UPDATED WITH REAL AUTH)
//  TrainerMatch
//
//  Now uses AuthManager for real user authentication
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var authManager = AuthManager.shared
    
    @State private var email = ""
    @State private var password = ""
    @State private var isTrainerLogin = true
    @State private var showingSignup = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Black background
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Logo
                        VStack(spacing: 20) {
                            TrainerMatchLogo(size: .large)
                                .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                                .padding(.top, 60)
                            
                            Text("TrainerMatch")
                                .font(.system(size: 44, weight: .heavy))
                                .italic()
                                .foregroundColor(.white)
                            
                            Text("Local Trainers, Real Results")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.tmGold)
                        }
                        .padding(.bottom, 40)
                        
                        // Login Type Selector
                        HStack(spacing: 0) {
                            Button(action: {
                                withAnimation {
                                    isTrainerLogin = false
                                }
                            }) {
                                Text("CLIENT")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundColor(isTrainerLogin ? .white.opacity(0.5) : .black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        isTrainerLogin ? Color.clear : Color.tmGold
                                    )
                            }
                            
                            Button(action: {
                                withAnimation {
                                    isTrainerLogin = true
                                }
                            }) {
                                Text("TRAINER")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundColor(isTrainerLogin ? .black : .white.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        isTrainerLogin ? Color.tmGold : Color.clear
                                    )
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.tmGold, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                        
                        // Login Form
                        VStack(spacing: 20) {
                            Text("LOGIN")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.tmGold)
                                .padding(.bottom, 8)
                            
                            // Error Message
                            if showingError {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.red.opacity(0.1))
                                    )
                            }
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                TextField("your@email.com", text: $email)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .textContentType(.emailAddress)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                SecureField("Enter password", text: $password)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                                    .textContentType(.password)
                            }
                            
                            // Forgot Password
                            Button(action: {}) {
                                Text("Forgot Password?")
                                    .font(.caption)
                                    .foregroundColor(.tmGold)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // Login Button
                            Button(action: handleLogin) {
                                Text("LOGIN")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.tmGold)
                                    )
                            }
                            .padding(.top, 8)
                            
                            // Divider
                            HStack {
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 1)
                                
                                Text("OR")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 12)
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 1)
                            }
                            .padding(.vertical, 12)
                            
                            // Sign Up Button
                            Button(action: {
                                showingSignup = true
                            }) {
                                Text("CREATE NEW ACCOUNT")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.tmGold, lineWidth: 2)
                                    )
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.05))
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 60)
                    }
                }
                
                // Navigate when authenticated
                if authManager.isAuthenticated {
                    NavigationLink(destination: destinationView(), isActive: .constant(true)) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingSignup) {
            // Pass authManager as environment object to signup views
            if isTrainerLogin {
                TrainerSignupView()
                    .environmentObject(authManager)
            } else {
                ClientSignupView()
                    .environmentObject(authManager)
            }
        }
        .onChange(of: authManager.isAuthenticated) { newValue in
            // When authentication changes, dismiss any signup sheet
            if newValue {
                print("🔐 Authentication detected! Dismissing signup...")
                showingSignup = false
            }
        }
    }
    
    private func handleLogin() {
        showingError = false
        
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please enter email and password"
            showingError = true
            return
        }
        
        let success: Bool
        if isTrainerLogin {
            success = authManager.loginTrainer(email: email, password: password)
        } else {
            success = authManager.loginClient(email: email, password: password)
        }
        
        if !success {
            errorMessage = "Invalid email or password"
            showingError = true
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if authManager.currentUserRole == .trainer {
            // TRAINER → Dashboard
            TrainerDashboard()
                .environmentObject(authManager)
        } else {
            // CLIENT → Profile
            if let clientProfile = authManager.currentClientProfile {
                ClientProfileMySpaceView(client: clientProfile.toClientProfile())
                    .environmentObject(authManager)
            } else {
                Text("Error loading profile")
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Extension to convert SavedClientProfile to ClientProfile
extension SavedClientProfile {
    func toClientProfile() -> ClientProfile {
        print("🔄 Converting SavedClientProfile to ClientProfile")
        print("   Name: \(fullName)")
        print("   Goals count: \(fitnessGoals.count)")
        
        return ClientProfile(
            name: fullName,
            age: age,
            city: city,
            state: state,
            memberSince: dateCreated,
            currentTrainer: nil,
            preferredServiceType: .inPerson,
            fitnessLevel: fitnessLevel,
            goals: fitnessGoals.isEmpty ? [.generalFitness] : Array(fitnessGoals),
            startingWeight: Int(targetWeight ?? 150),
            currentWeight: Int(targetWeight ?? 150),
            targetWeight: Int(targetWeight ?? 150),
            medicalConditions: medicalConditions.isEmpty ? "None" : medicalConditions,
            injuries: injuries.isEmpty ? "None" : injuries,
            allergies: allergies.isEmpty ? "None" : allergies,
            medications: medications.isEmpty ? "None" : medications,
            currentStreak: 0,
            workoutsCompleted: 0,
            workoutsThisWeek: 0,
            progressPhotoCount: 0,
            measurements: ClientProfile.ClientMeasurements(
                chest: 0,
                waist: 0,
                hips: 0,
                arms: 0
            )
        )
    }
}

#Preview {
    LoginView()
}
