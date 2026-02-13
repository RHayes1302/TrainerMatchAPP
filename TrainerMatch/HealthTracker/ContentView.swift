
//
//  ContentView.swift
//  TrainerMatch
//
//  Main health tracker view with gold dashboard
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        NavigationView {
            GoldTripleRingDashboard()
                .environmentObject(viewModel)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Health Tracker")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
