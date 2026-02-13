//
//  HealthViewModel.swift
//  HealthTracker
//
//  Created by Ramone Hayes on 2/3/26.
//

import Foundation
import HealthKit

// MARK: - DAILY STEP MODEL
struct DailyStep: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

// MARK: - HEALTH VIEW MODEL
class HealthViewModel: ObservableObject {
    
    // Published properties for UI
    @Published var steps: Int = 0
    @Published var distance: Double = 0
    @Published var activityStatus: String = "Not Active"
    @Published var authStatus: String = "Not requested"
    @Published var isAuthorized: Bool = false
    
    // Weekly history
    @Published var history: [DailyStep] = []
    
    private let healthStore = HKHealthStore()
    
    // MARK: - INIT
    init() {
        checkHealthDataAvailability()
    }
    
    // MARK: - CHECK HEALTH DATA
    func checkHealthDataAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            print("Health data is available")
        } else {
            print("Health data is not available on this device")
            authStatus = "Not available on this device"
        }
    }
    
    // MARK: - REQUEST AUTHORIZATION
    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.authStatus = "Authorized"
                    print("Authorized")
                } else {
                    self.authStatus = "Not Authorized"
                    print("Error using HealthKit")
                }
            }
        }
    }
    
    // MARK: - FETCH TODAY'S STEPS
    func fetchTodaySteps() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error Fetching Steps: \(error.localizedDescription)")
                    self.steps = 0
                    self.activityStatus = "Error"
                    return
                }
                
                if let sum = result?.sumQuantity() {
                    self.steps = Int(sum.doubleValue(for: .count()))
                    self.updateActivityStatus()
                    print("Fetched steps: \(self.steps)")
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - FETCH TODAY'S DISTANCE
    func fetchTodayDistance() {
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching distance: \(error.localizedDescription)")
                    self.distance = 0
                    return
                }
                
                if let sum = result?.sumQuantity() {
                    self.distance = sum.doubleValue(for: HKUnit.meter())
                    print("Fetched distance: \(self.distance) meters")
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - OBSERVE STEPS
    func startObservingSteps() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { _, completionHandler, error in
            if let error = error {
                print("Observer query error: \(error.localizedDescription)")
                return
            }
            self.fetchTodaySteps()
            completionHandler()
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - UPDATE ACTIVITY STATUS
    private func updateActivityStatus() {
        switch steps {
        case ..<2000:
            activityStatus = "Sedentary"
        case 2000..<5000:
            activityStatus = "Lightly Active"
        case 5000..<7000:
            activityStatus = "Moderately Active"
        case 7000..<10000:
            activityStatus = "Active"
        default:
            activityStatus = "Very Active"
        }
    }
    
    // MARK: - FETCH PAST WEEK STEPS
    func fetchPastWeekSteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let calendar = Calendar.current
        history = []
        
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let startOfDay = calendar.startOfDay(for: day)
                let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
                
                let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                    DispatchQueue.main.async {
                        let steps = Int(result?.sumQuantity()?.doubleValue(for: .count()) ?? 0)
                        let daily = DailyStep(date: startOfDay, steps: steps)
                        self.history.append(daily)
                        self.history.sort { $0.date < $1.date }
                    }
                }
                
                healthStore.execute(query)
            }
        }
    }
}
