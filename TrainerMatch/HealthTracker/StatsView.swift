//
//  StatsView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  StatsView.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI

struct StatsGridView: View {
    let steps: Int
    let distance: Double
    let gold: Color
    let highScore: Int
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("\(String(format: "%.2f", distance / 1000)) km")
                    .font(.title3)
                    .bold()
                    .foregroundColor(gold)
                Text("Distance")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(15)
            .shadow(color: gold.opacity(0.5), radius: 5, x: 0, y: 3)
            
            VStack(spacing: 10) {
                Text("\(Int(Double(steps) * 0.04)) kcal")
                    .font(.title3)
                    .bold()
                    .foregroundColor(gold)
                Text("Calories")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(15)
            .shadow(color: gold.opacity(0.5), radius: 5, x: 0, y: 3)
        }
    }
}
