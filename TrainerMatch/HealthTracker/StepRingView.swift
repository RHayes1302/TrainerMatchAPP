
//  StepRingView.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI

struct StepRingsView: View {
    let steps: Int
    let distance: Double
    let stepGoal: Double
    let distanceGoal: Double
    let calorieGoal: Double
    let gold: Color
    @Binding var showCongrats: Bool
    
    @State private var glowAnimation: Bool = false
    
    var body: some View {
        ZStack {
            // Step ring
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 24)
            Circle()
                .trim(from: 0.0, to: min(Double(steps)/stepGoal, 1.0))
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [gold, gold.opacity(0.7)]), center: .center),
                    style: StrokeStyle(lineWidth: 24, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: steps)
            
            // Distance ring
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 18)
            Circle()
                .trim(from: 0.0, to: min(distance/distanceGoal, 1.0))
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [gold.opacity(0.8), gold.opacity(0.5)]), center: .center),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 180, height: 180)
                .animation(.easeInOut(duration: 0.8), value: distance)
            
            // Calories ring
            Circle()
                .stroke(Color.gray.opacity(0.1), lineWidth: 12)
            Circle()
                .trim(from: 0.0, to: min(Double(steps)*0.04/calorieGoal, 1.0))
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [gold.opacity(0.6), gold.opacity(0.3)]), center: .center),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 140, height: 140)
                .animation(.easeInOut(duration: 0.8), value: steps)
            
            // Center text
            VStack(spacing: 4) {
                Text("\(steps)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Text("Steps")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            // Congrats overlay
            if showCongrats {
                Text("🎉 New Personal Best! 🎉")
                    .font(.headline)
                    .bold()
                    .foregroundColor(gold)
                    .transition(.scale.combined(with: .opacity))
                    .offset(y: -150)
            }
        }
        .frame(width: 220, height: 220)
        .shadow(color: gold.opacity(0.5), radius: 10, x: 0, y: 5)
        .continuousGlow(active: true, color: gold)
    }
}

// Continuous Glow Modifier
extension View {
    func continuousGlow(active: Bool, color: Color) -> some View {
        self.overlay(
            Circle()
                .stroke(color.opacity(active ? 0.5 : 0), lineWidth: active ? 20 : 0)
                .scaleEffect(active ? 1.1 : 1.0)
                .blur(radius: active ? 10 : 0)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: active
                )
        )
    }
}
