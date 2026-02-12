//
//  TrainerMatchTheme.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

// MARK: - TrainerMatch Color Theme
extension Color {
    // Primary Colors
    static let tmGold = Color(red: 0.88, green: 0.73, blue: 0.25) // Main gold/yellow
    static let tmGoldDark = Color(red: 0.82, green: 0.66, blue: 0.18) // Darker gold
    static let tmBlack = Color.black
    static let tmWhite = Color.white
    
    // Background Gradients
    static let tmGoldGradientLight = Color(red: 0.95, green: 0.82, blue: 0.45)
    static let tmGoldGradientDark = Color(red: 0.92, green: 0.78, blue: 0.38)
    
    // Accent Colors
    static let tmRed = Color.red // For "FEATURED" badges
    static let tmBlue = Color(red: 0.2, green: 0.4, blue: 0.8) // For "IN-PERSON" badges
    static let tmPurple = Color(red: 0.6, green: 0.3, blue: 0.8) // For "ONLINE" badges
    static let tmGray = Color.gray // For gender badges
    
    // Gradients
    static func tmGoldGradient() -> LinearGradient {
        LinearGradient(
            colors: [tmGold, tmGoldDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func tmBackgroundGradient() -> LinearGradient {
        LinearGradient(
            colors: [tmGoldGradientLight, tmGoldGradientDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Common Button Styles
struct TMPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .heavy))
            .tracking(0.5)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 27)
                    .fill(Color.tmBlack)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct TMSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .heavy))
            .tracking(0.5)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 27)
                    .fill(Color.tmGold)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct TMOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .heavy))
            .tracking(0.5)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 27)
                    .stroke(Color.tmBlack, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
