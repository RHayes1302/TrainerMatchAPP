//
//  ActivityStatusCard.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct ActivityStatusCard:View {
    let activityStatus:String
    let authStatus:String
    let isAuthorized:Bool
    
    var body: some View {
        
        
        VStack(alignment: .leading,spacing: 15){
            HStack{
                Image(systemName: "heart.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.red)
                
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
                    .foregroundColor(Color.primary)
                
                
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
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}


#Preview {
    VStack(spacing:20){
        // State 1
        ActivityStatusCard(activityStatus: "Active", authStatus: "Authorized", isAuthorized: true)
        // State 2
        ActivityStatusCard(activityStatus: "Sendentary", authStatus: "Not Requested", isAuthorized: false)
    }.padding()
}
