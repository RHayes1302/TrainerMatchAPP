
//
//  HealthAuthButtonView.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI

struct HealthAuthButtonView: View {
    let isAuthorized: Bool
    let gold: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(isAuthorized ? "Refresh Data" : "Authorize HealthKit")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(gold)
                .cornerRadius(15)
                .shadow(color: gold.opacity(0.5), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    HealthAuthButtonView(isAuthorized: false, gold: Color(red: 212/255, green: 175/255, blue: 55/255)) {
        print("Button pressed")
    }
    .padding()
}
