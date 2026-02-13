//
//  HealthViewModel.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import Foundation // <- Primitive TYPES like strings,ints,etc
import HealthKit // Apple's framework to access health data from our phone

class HealthViewModel:ObservableObject{
    
    @Published var steps: Int = 0
    @Published var distance:Double = 0.0
    @Published var activityStatus: String = "Not Active"
    @Published var authStatus: String = "Not requested"
    @Published var isAuthorized: Bool = false
    
    
    private let healthStore:HKHealthStore = HKHealthStore()
    
    // Runs when the ViewModel is created
    // Immediately checks if HealthKit is available
    init(){
        checkHealthDataAvailability()
    }
    
    // MARK: Check for the health data
    // HKHealthStore.isHealthDataAvailable(): Returns true/false
    // Some devices (iPad, Simulator) don't have HealthKit
    private func checkHealthDataAvailability(){
        if HKHealthStore.isHealthDataAvailable(){
            print("Ir available on this device")
        }else{
            print("Not available on this device")
            authStatus = "Not Available"
        }
    }
    
    //MARK: Auth
    func requestAuthorization(){
        
        // Define the types of health data we want to read
        // We use set -> Set: Collection with unique items (no duplicates)
        let typeToRead:Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typeToRead){ success , error  in
            
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.authStatus = "Authorized"
                    
                    // Add some extra functions here
                    self.fetchTodaySteps()
                    self.fetchTodayDistance()
                    
                } else{
                    
                    self.isAuthorized = false
                    self.authStatus = "Denied"
                    
                    if let error = error{
                        print("Error using HealthKit at: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        
        
        
    }
    
    
    // MARK: fetch steps
    
    func fetchTodaySteps(){
        
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("No steps / not available")
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType:stepCountType,quantitySamplePredicate: predicate,options: .cumulativeSum){ query, result,error in
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Error FETCHING STEPS")
                    self.steps = 0
                    self.updateActivityStatus()
                    return
                }
                
                if let result = result, let sum = result.sumQuantity() {
                    let steps = Int(sum.doubleValue(for: HKUnit.count()))
                    self.steps = steps
                    self.updateActivityStatus()
                    
                    print("Fetch steps: \(steps)")
                    
                }else {
                    print("No step data available")
                    self.steps = 0
                    self.updateActivityStatus()
                }
            }
            
        }
        
        healthStore.execute(query)
    }
    
    
    func fetchTodayDistance(){
        
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("No distance / not available")
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query =  HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate,options: .cumulativeSum){query, result,error in
            
            DispatchQueue.main.async {
                // Catch any error
                if let error = error {
                    print("Error message: \(error.localizedDescription)")
                    self.distance = 0.0
                    return
                }
                if let result =  result, let sum = result.sumQuantity(){
                    let distanceInMeters = sum.doubleValue(for:HKUnit.meter())
                    let distanceInKilometers = distanceInMeters/1000.0
                    self.distance = distanceInMeters
                    print("Distance fetch:\(distanceInKilometers)")
                }else {
                    print("No distance available")
                    self.distance = 0.0
                }
            }
            
        }
        
        healthStore.execute(query)
    }
    
    
    // Create an observer query to monitor step count changes
    func startObservingSteps(){
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("Step count not available")
            return
        }
        
             
        
        let query = HKObserverQuery(sampleType: stepCountType, predicate:nil){
            query,completionHandler,error in
            
            if let error = error {
                print("Observer query error: \(error.localizedDescription)")
                return
            }
            
            
            // When new step data is available, fetch the updated count
            self.fetchTodaySteps()
            self.fetchTodayDistance()
            
            completionHandler()
            
        }
        
        healthStore.execute(query)
        
    }
    
    private func updateActivityStatus(){
        if steps < 2000{
            activityStatus = "Sedentary"
        }else if steps < 5000 {
            activityStatus = "Lightly Active"
        }else if steps < 7000 {
            activityStatus = "Moderately Active"
        }else if steps < 10000 {
            activityStatus = "Active"
        }else {
            activityStatus = "Very Active"
        }
        
    }
    
    
    
    
}
