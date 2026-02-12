//
//  StepCardView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct StepCardView: View {
    let goal: Int = 10000
    let steps: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header with TrainerMatch Logo
            HStack {
                TrainerMatchLogo(size: .small)
                    .shadow(color: .tmGold.opacity(0.2), radius: 5, x: 0, y: 2)
                
                Spacer()
                
                Image(systemName: "figure.walk.circle.fill")
                    .font(.title2)
                    .foregroundColor(.tmGold)
            }
            
            // Title
            Text("Steps Today")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Steps Count
            HStack(alignment: .firstTextBaseline) {
                Text("\(steps)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.tmGold)
                
                Text("steps")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            // Progress Bar
            ProgressView(value: Double(steps), total: Double(goal))
                .tint(.tmGold)
            
            // Goal Text
            Text("Goal \(goal.formatted()) steps")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.white, Color(.systemGray6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.tmGold.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .tmGold.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    StepCardView(steps: 7551)
        .padding()
}
