//
//  WelcomeView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct WelcomeView: View {
    @State private var selectedDestination: NavigationDestination? = nil
    @State private var showingMenuSheet = false
    @State private var showingLogin = false
    @State private var showingSignupChoice = false
    
    enum NavigationDestination: Identifiable {
        case myHealth
        case trainerDashboard
        case aboutUs
        case successStories
        case healthyHacks
        case faqs
        case contact
        case trainerSearch
        case trainerSignup
        case nearbyTrainers
        case clientSignup
        
        var id: String {
            switch self {
            case .myHealth: return "myHealth"
            case .trainerDashboard: return "trainerDashboard"
            case .aboutUs: return "aboutUs"
            case .successStories: return "successStories"
            case .healthyHacks: return "healthyHacks"
            case .faqs: return "faqs"
            case .contact: return "contact"
            case .trainerSearch: return "trainerSearch"
            case .trainerSignup: return "trainerSignup"
            case .nearbyTrainers: return "nearbyTrainers"
            case .clientSignup: return "clientSignup"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Pure black background
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // TrainerMatch Logo
                    VStack(spacing: 20) {
                        TrainerMatchLogo(size: .large)
                            .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 6) {
                            Text("TrainerMatch")
                                .font(.system(size: 50, weight: .heavy))
                                .italic()
                                .foregroundColor(.white)
                                .shadow(color: .tmGold.opacity(0.3), radius: 10, x: 0, y: 4)
                            
                            Text("Local Trainers, Real Results")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.tmGold)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.top, 80)
                    
                    Spacer().frame(height: 40)
                    
                    Text("Match with top fitness professionals based on your wellness needs, offering diverse specialties and services, all just one click away.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 35)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 18) {
                        // IN-PERSON TRAINERS Button
                        Button(action: {
                            selectedDestination = .nearbyTrainers
                        }) {
                            HStack {
                                Image(systemName: "person.2.circle.fill")
                                    .font(.title3)
                                Text("IN-PERSON TRAINERS")
                                    .font(.system(size: 15, weight: .heavy))
                                    .tracking(0.5)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                                RoundedRectangle(cornerRadius: 29)
                                    .fill(Color.tmGoldGradient())
                            )
                            .shadow(color: .tmGold.opacity(0.5), radius: 15, x: 0, y: 8)
                        }
                        
                        // Search All Trainers Button
                        Button(action: {
                            selectedDestination = .trainerSearch
                        }) {
                            HStack {
                                Spacer()
                                Text("SEARCH ALL TRAINERS")
                                    .font(.system(size: 15, weight: .heavy))
                                    .tracking(0.5)
                                    .foregroundColor(.tmGold)
                                Spacer()
                            }
                            .frame(height: 58)
                            .background(
                                RoundedRectangle(cornerRadius: 29)
                                    .fill(Color.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 29)
                                            .stroke(Color.tmGold, lineWidth: 2.5)
                                    )
                            )
                            .shadow(color: .tmGold.opacity(0.3), radius: 12, x: 0, y: 6)
                        }

                        // Join the Movement Button - SHOWS CHOICE
                        Button(action: {
                            showingSignupChoice = true
                        }) {
                            VStack(spacing: 4) {
                                Text("JOIN THE MOVEMENT")
                                    .font(.system(size: 15, weight: .heavy))
                                    .tracking(0.5)
                                Text("Start Your Journey")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 29)
                                    .fill(Color.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 29)
                                            .stroke(Color.white, lineWidth: 2.5)
                                    )
                            )
                            .shadow(color: .white.opacity(0.3), radius: 12, x: 0, y: 6)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 70)
                }
                
                // Hidden NavigationLinks for programmatic navigation
                NavigationLink(
                    destination: destinationView(for: selectedDestination),
                    tag: selectedDestination ?? .myHealth,
                    selection: $selectedDestination
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Hamburger Menu - LEFT
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingMenuSheet = true
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                            .foregroundColor(.tmGold)
                            .padding(8)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                }
                
                // Login Button - RIGHT
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLogin = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "person.circle.fill")
                                .font(.title3)
                            Text("LOGIN")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.tmGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
            }
            .toolbarBackground(Color.black.opacity(0.95), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingMenuSheet) {
                MenuSheetView(selectedDestination: $selectedDestination, showingMenuSheet: $showingMenuSheet)
            }
            .sheet(isPresented: $showingLogin) {
                LoginView()
            }
            .sheet(isPresented: $showingSignupChoice) {
                SignupChoiceView(selectedDestination: $selectedDestination, showingSignupChoice: $showingSignupChoice)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination?) -> some View {
        switch destination {
        case .myHealth:
            ContentView()
        case .trainerDashboard:
            TrainerDashboardView()
        case .aboutUs:
            AboutUsView()
        case .successStories:
            SuccessStoriesView()
        case .healthyHacks:
            HealthyHacksView()
        case .faqs:
            FAQsView()
        case .contact:
            ContactView()
        case .trainerSearch:
            TrainerSearchView()
        case .trainerSignup:
            TrainerSignupView()
        case .nearbyTrainers:
            NearbyTrainersView()
        case .clientSignup:
            ClientSignupView()
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Menu Sheet View
struct MenuSheetView: View {
    @Binding var selectedDestination: WelcomeView.NavigationDestination?
    @Binding var showingMenuSheet: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Logo
                    VStack(spacing: 20) {
                        TrainerMatchLogo(size: .large)
                            .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Text("TrainerMatch")
                            .font(.system(size: 32, weight: .bold))
                            .italic()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    
                    // QUICK ACCESS Section
                    VStack(alignment: .leading, spacing: 0) {
                        Text("QUICK ACCESS")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.tmGold)
                            .padding(.bottom, 12)
                        
                        MenuButton(
                            icon: "heart.fill",
                            title: "My Health",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .myHealth
                                }
                            }
                        )
                        
                        MenuButton(
                            icon: "person.3.fill",
                            title: "Trainer Dashboard",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .trainerDashboard
                                }
                            }
                        )
                        
                        MenuButton(
                            icon: "dumbbell.fill",
                            title: "Become a Trainer",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .trainerSignup
                                }
                            }
                        )
                    }
                    .padding(.bottom, 32)
                    
                    // INFORMATION Section
                    VStack(alignment: .leading, spacing: 0) {
                        Text("INFORMATION")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.tmGold)
                            .padding(.bottom, 12)
                        
                        MenuButton(
                            icon: "info.circle",
                            title: "About Us",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .aboutUs
                                }
                            }
                        )
                        
                        MenuButton(
                            icon: "star.fill",
                            title: "Success Stories",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .successStories
                                }
                            }
                        )
                        
                        MenuButton(
                            icon: "heart.text.square",
                            title: "Healthy Hacks",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .healthyHacks
                                }
                            }
                        )
                        
                        MenuButton(
                            icon: "questionmark.circle",
                            title: "FAQs",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .faqs
                                }
                            }
                        )
                        
                        MenuButton(
                            icon: "envelope",
                            title: "Contact",
                            action: {
                                showingMenuSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    selectedDestination = .contact
                                }
                            }
                        )
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, 20)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                showingMenuSheet = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.tmGold)
                    .padding(20)
            }
        }
    }
}

// MARK: - Menu Button
struct MenuButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.tmGold)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

// MARK: - Signup Choice View
struct SignupChoiceView: View {
    @Binding var selectedDestination: WelcomeView.NavigationDestination?
    @Binding var showingSignupChoice: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Logo & Title
                VStack(spacing: 20) {
                    TrainerMatchLogo(size: .large)
                        .shadow(color: .tmGold.opacity(0.3), radius: 20, x: 0, y: 10)
                        .padding(.top, 60)
                    
                    Text("Join TrainerMatch")
                        .font(.system(size: 36, weight: .bold))
                        .italic()
                        .foregroundColor(.white)
                    
                    Text("Choose how you want to get started")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.bottom, 50)
                
                // Choice Cards
                VStack(spacing: 20) {
                    // Client Card
                    Button(action: {
                        showingSignupChoice = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            selectedDestination = .clientSignup
                        }
                    }) {
                        VStack(spacing: 16) {
                            Image(systemName: "figure.walk")
                                .font(.system(size: 50))
                                .foregroundColor(.tmGold)
                            
                            Text("I'm a Client")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Find trainers, track workouts, and reach your fitness goals")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.tmGold, lineWidth: 2)
                                )
                        )
                    }
                    
                    // Trainer Card
                    Button(action: {
                        showingSignupChoice = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            selectedDestination = .trainerSignup
                        }
                    }) {
                        VStack(spacing: 16) {
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.tmGold)
                            
                            Text("I'm a Trainer")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Grow your business, manage clients, and build your brand")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.tmGold, lineWidth: 2)
                                )
                        )
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                showingSignupChoice = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.tmGold)
                    .padding(20)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
