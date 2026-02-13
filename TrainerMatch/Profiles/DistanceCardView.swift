//
//  DistanceCardView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct DistanceCardView:View {

    let distance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack{
                Image(systemName: "map.circle.fill")
                    .font(.system(size: 33))
                    .foregroundColor(Color.blue)
                
                Text("Distance")
                    .font(.headline)
                
                Spacer()
            }
            HStack(alignment: .firstTextBaseline){
                Text(String(format: "%.2f", distance))
                    .font(.system(size: 48,weight: .bold))
                    .foregroundColor(Color.primary)
                Text("Km")
                    .font(.title3)
                    .foregroundColor(Color.gray)
            }
        }
        
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}


#Preview {
    DistanceCardView(distance: 20.0123).padding()
}
