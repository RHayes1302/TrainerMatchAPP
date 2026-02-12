//
//  FormField.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI

// MARK: - Shared Form Field Component
// This component is used by both ClientSignupView and TrainerSignupView
struct FormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .words
    var contentType: UITextContentType? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .textContentType(contentType)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .textContentType(contentType)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 20) {
            FormField(
                label: "Email",
                text: .constant(""),
                placeholder: "your@email.com",
                keyboardType: .emailAddress,
                autocapitalization: .never,
                contentType: .emailAddress
            )
            
            FormField(
                label: "Password",
                text: .constant(""),
                placeholder: "Enter password",
                isSecure: true,
                contentType: .newPassword
            )
        }
        .padding()
    }
}
