//
//  MainAppView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct MainAppView: View {
    @State private var selectedRole: UserRole = .client
    
    var body: some View {
        TabView(selection: $selectedRole) {
            // Client View - Personal Health Tracking
            ContentView()
                .tabItem {
                    Label("My Health", systemImage: "heart.fill")
                }
                .tag(UserRole.client)
            
            // Trainer View - Client Management
            TrainerDashboardView()
                .tabItem {
                    Label("My Clients", systemImage: "person.3.fill")
                }
                .tag(UserRole.trainer)
        }
    }
}

#Preview {
    MainAppView()
}
