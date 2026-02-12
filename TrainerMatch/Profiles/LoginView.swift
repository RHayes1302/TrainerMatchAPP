//
//  LoginView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isTrainerLogin = true
    @State private var showingSignup = false
    @State private var navigateToApp = false
    
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
                            }
                            
                            // Forgot Password
                            Button(action: {}) {
                                Text("Forgot Password?")
                                    .font(.caption)
                                    .foregroundColor(.tmGold)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // Login Button
                            Button(action: {
                                navigateToApp = true
                            }) {
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
                
                // Hidden navigation links
                NavigationLink(destination: destinationView(), isActive: $navigateToApp) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingSignup) {
            if isTrainerLogin {
                TrainerSignupView()
            } else {
                ClientSignupView()
            }
        }
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if isTrainerLogin {
            TrainerDashboardView()
        } else {
            ContentView() // Client health view
        }
    }
}

#Preview {
    LoginView()
}
