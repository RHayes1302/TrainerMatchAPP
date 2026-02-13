//
//  HeaderSectionView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

//
//  HeaderSection.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/3/26.
//

import SwiftUI

struct HeaderSectionView: View {
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: "figure.walk")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 212/255, green: 175/255, blue: 55/255))
            
            Text("Go for Gold! 🏆")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Daily Activity Dashboard")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
