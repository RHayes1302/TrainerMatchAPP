//
//  ContentView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel: HealthViewModel = HealthViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 20){
                    HeaderSectionView()
                    StepCardView(steps: viewModel.steps)
                    DistanceCardView(distance: viewModel.distance / 1000)
                    ActivityStatusCard(activityStatus: viewModel.activityStatus, authStatus: viewModel.authStatus, isAuthorized: viewModel.isAuthorized)
                    Spacer()
                    
                }
                .padding()
            }.navigationTitle("Health Tracker")
                .onAppear{
                    viewModel.requestAuthorization()
                }
                .refreshable {
                    viewModel.fetchTodaySteps()
                    viewModel.fetchTodayDistance()
                }
        }
        
        
    }
}

#Preview {
    ContentView()
}
