//
//  ActivityStatusCard.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/3/26.
//

import SwiftUI

struct ActivityStatusCard: View {
    let activityStatus: String
    let authStatus: String
    let isAuthorized: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack{
                Image(systemName: "heart.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(red: 212/255, green: 175/255, blue: 55/255))
                
                Text("Activity Status")
                    .font(.headline)
                Spacer()
            }
            
            HStack{
                Text("Status")
                    .font(.body)
                    .foregroundColor(Color.gray)
                
                Text(activityStatus)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            HStack{
                Text("Authorization status")
                    .font(.body)
                    .foregroundColor(Color.gray)
                
                Text(authStatus)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(isAuthorized ? .green : .orange)
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(15)
        .shadow(color: Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.5), radius: 5, x: 0, y: 3)
    }
}
