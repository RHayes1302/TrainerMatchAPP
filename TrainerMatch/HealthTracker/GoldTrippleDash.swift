//
//  GoldTrippleDash.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

import SwiftUI

struct GoldTripleRingDashboard: View {
    
    // Use the shared HealthViewModel from ContentView/App
    @EnvironmentObject var viewModel: HealthViewModel
    
    let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
    
    let stepGoal: Double = 10000
    let distanceGoal: Double = 5000
    let calorieGoal: Double = 500
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "highScore")
    @State private var showCongrats: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                
                // Header
                DashboardHeaderView()
                
                // Triple Rings
                StepRingsView(
                    steps: viewModel.steps,
                    distance: viewModel.distance,
                    stepGoal: stepGoal,
                    distanceGoal: distanceGoal,
                    calorieGoal: calorieGoal,
                    gold: gold,
                    showCongrats: $showCongrats
                )
                
                StatsGridView(
                    steps: viewModel.steps,
                    distance: viewModel.distance,
                    gold: gold,
                    highScore: highScore
                )
                
                Text("Personal Best: \(highScore) steps")
                    .font(.headline)
                    .foregroundColor(gold)
                    .bold()
                
                ActivityStatusCard(
                    activityStatus: viewModel.activityStatus,
                    authStatus: viewModel.authStatus,
                    isAuthorized: viewModel.isAuthorized
                )
                
                HealthAuthButtonView(isAuthorized: viewModel.isAuthorized, gold: gold) {
                    viewModel.requestAuthorization()
                    if viewModel.isAuthorized {
                        viewModel.fetchTodaySteps()
                        viewModel.fetchTodayDistance()
                        viewModel.startObservingSteps()
                        viewModel.fetchPastWeekSteps()
                        checkPersonalBest()
                    }
                }
                
                if !viewModel.history.isEmpty {
                    WeeklyHistoryChartView(history: viewModel.history, gold: gold, highScore: highScore)
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            if viewModel.isAuthorized {
                viewModel.fetchTodaySteps()
                viewModel.fetchTodayDistance()
                viewModel.startObservingSteps()
                viewModel.fetchPastWeekSteps()
                checkPersonalBest()
            }
        }
    }
    
    func checkPersonalBest() {
        if viewModel.steps > highScore {
            highScore = viewModel.steps
            UserDefaults.standard.set(highScore, forKey: "highScore")
            withAnimation(.easeInOut) { showCongrats = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { showCongrats = false }
            }
        }
    }
}

#Preview {
    GoldTripleRingDashboard()
        .environmentObject(HealthViewModel()) // inject the environment object
}
