//
//  TrainerDetailView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct TrainerDetailView: View {
    let trainer: (name: String, specialty: String, serviceType: String, gender: String, image: String)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Image with Badges
                ZStack(alignment: .bottomLeading) {
                    // Profile Photo
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 300)
                        
                        Image(systemName: trainer.image)
                            .font(.system(size: 100))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Service Type Badges (Top of photo)
                    VStack(spacing: 8) {
                        ForEach(Array(serviceBadges.enumerated()), id: \.offset) { index, badge in
                            HStack {
                                Text(badge.text)
                                    .font(.system(size: 11, weight: .heavy))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(badge.color)
                                    )
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .frame(height: 300)
                
                // Content Section
                VStack(alignment: .leading, spacing: 24) {
                    // Trainer Name
                    Text(trainer.name)
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 20)
                    
                    // Specialties & Formats Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Specialties & Formats")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.85, green: 0.7, blue: 0.2))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Specialties:")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text(trainer.specialty)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Workout Format:")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text(trainer.serviceType)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Professional Background Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Professional Background")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.85, green: 0.7, blue: 0.2))
                        
                        Text(professionalBio)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(6)
                        
                        // Training Philosophy
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Training Philosophy")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            Text("My approach focuses on tailored sessions, precise alignment and mindful movement. I believe in empowering clients with knowledge and self-awareness.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        // Training Style
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Training Style")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                BulletPoint(text: "Private and group sessions")
                                BulletPoint(text: "Mat and reformer work")
                                BulletPoint(text: "Injury rehabilitation and prevention")
                                BulletPoint(text: "Mind-body connection and breathing techniques")
                            }
                        }
                        
                        // What to Expect
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What to Expect")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                BulletPoint(text: "Personalized attention and guidance")
                                BulletPoint(text: "Challenging yet supportive environment")
                                BulletPoint(text: "Progressive and adaptive workouts")
                            }
                        }
                        
                        Text("Let's connect and embark on your \(trainer.specialty) journey!")
                            .font(.body)
                            .italic()
                            .padding(.top, 8)
                    }
                    
                    Divider()
                    
                    // Contact Trainer Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Trainer")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.85, green: 0.7, blue: 0.2))
                        
                        ContactForm()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Share trainer profile
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private var serviceBadges: [(text: String, color: Color)] {
        var badges: [(String, Color)] = []
        
        // Featured badge
        if Int.random(in: 0...1) == 0 {
            badges.append(("FEATURED", .red))
        }
        
        // Service type
        if trainer.serviceType.contains("In-Person") {
            badges.append(("IN-PERSON", Color(red: 0.5, green: 0.5, blue: 0.5)))
        }
        
        // Gender
        badges.append((trainer.gender.uppercased(), Color(red: 0.4, green: 0.4, blue: 0.4)))
        
        return badges
    }
    
    private var professionalBio: String {
        "Hello! I'm \(trainer.name), a passionate and dedicated \(trainer.specialty) trainer with over 10 years of experience helping clients achieve their fitness goals. My journey as a trainer began with a passion for movement and a desire to share its transformative power."
    }
}

// MARK: - Bullet Point
struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("·")
                .font(.title3)
                .foregroundColor(.secondary)
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Contact Form
struct ContactForm: View {
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var message = ""
    @State private var agreedToTerms = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Send A Message")
                .font(.headline)
            
            // Name Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Name")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                TextField("Enter your name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Phone Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Phone")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                TextField("Enter your phone", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
            }
            
            // Email Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            // Message Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Message")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                TextEditor(text: $message)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Terms Agreement
            HStack(alignment: .top, spacing: 8) {
                Button(action: {
                    agreedToTerms.toggle()
                }) {
                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreedToTerms ? Color(red: 0.85, green: 0.7, blue: 0.2) : .gray)
                }
                
                Text("You agree to the Terms of Use")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Submit Button
            Button(action: {
                submitForm()
            }) {
                Text("REQUEST INFORMATION")
                    .font(.system(size: 14, weight: .heavy))
                    .tracking(0.5)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black)
                    )
            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.5)
            .padding(.top, 8)
        }
        .alert("Message Sent!", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
                clearForm()
            }
        } message: {
            Text("The trainer will get back to you soon!")
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !phone.isEmpty && !email.isEmpty && !message.isEmpty && agreedToTerms
    }
    
    private func submitForm() {
        showingAlert = true
    }
    
    private func clearForm() {
        name = ""
        phone = ""
        email = ""
        message = ""
        agreedToTerms = false
    }
}

#Preview {
    NavigationView {
        TrainerDetailView(
            trainer: (name: "Cesarina Jones", specialty: "Pilates", serviceType: "In-Person", gender: "Female", image: "figure.yoga")
        )
    }
}
