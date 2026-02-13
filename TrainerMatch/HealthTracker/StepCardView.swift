//
//  StepCard.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/3/26.
//

import SwiftUI

struct StepCardView: View {
    let goal: Int = 10000
    let steps: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack{
                Image(systemName: "figure.walk.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(red: 212/255, green: 175/255, blue: 55/255))
                
                Text("Steps Today")
                    .font(.headline)
                
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline){
                Text("\(steps)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                Text("steps")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: Double(steps), total: Double(goal))
                .tint(Color(red: 212/255, green: 175/255, blue: 55/255))
            
            Text("Go for Gold! \(goal) steps")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(15)
        .shadow(color: Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.5), radius: 5, x: 0, y: 3)
    }
}
