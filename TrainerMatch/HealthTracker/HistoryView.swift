//
//  HistoryView.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/11/26.
//

import SwiftUI

struct WeeklyHistoryChartView: View {
    let history: [DailyStep]
    let gold: Color
    let highScore: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last 7 Days Steps")
                .font(.headline)
                .foregroundColor(.white)
            
            chartView
        }
        .padding()
        .background(Color.black)
        .cornerRadius(15)
        .shadow(color: gold.opacity(0.5), radius: 5, x: 0, y: 3)
    }
    
    private var chartView: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(history) { day in
                barView(for: day)
            }
        }
        .frame(height: 150)
    }
    
    private func barView(for day: DailyStep) -> some View {
        VStack {
            Rectangle()
                .fill(day.steps >= highScore ? gold : gold.opacity(0.6))
                .frame(height: barHeight(for: day.steps))
            Text(shortDay(day.date))
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
    
    private func barHeight(for steps: Int) -> CGFloat {
        let maxScore = max(highScore, 1)
        return CGFloat(steps) / CGFloat(maxScore) * 150
    }
    
    func shortDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}
