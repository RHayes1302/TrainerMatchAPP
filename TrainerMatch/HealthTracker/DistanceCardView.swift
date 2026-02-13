//
//  DistanceCard.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/3/26.
//

import SwiftUI

struct DistanceCardView: View {
    let distance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack{
                Image(systemName: "map.circle.fill")
                    .font(.system(size: 33))
                    .foregroundColor(Color(red: 212/255, green: 175/255, blue: 55/255))
                
                Text("Distance")
                    .font(.headline)
                
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline){
                Text(String(format: "%.2f", distance))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Km")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(15)
        .shadow(color: Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.5), radius: 5, x: 0, y: 3)
    }
}
