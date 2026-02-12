//
//  LocationManager.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/11/26.
//

import Foundation
import CoreLocation
import Combine

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
    }
    
    func requestLocation() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            locationManager.requestLocation()
        case .denied, .restricted:
            errorMessage = "Location access denied. Please enable in Settings."
        @unknown default:
            break
        }
    }
    
    func checkAuthorizationStatus() {
        authorizationStatus = locationManager.authorizationStatus
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Unable to determine location: \(error.localizedDescription)"
                    return
                }
                
                if let placemark = placemarks?.first {
                    self.city = placemark.locality ?? ""
                    self.state = placemark.administrativeArea ?? ""
                }
            }
        }
    }
    
    // Calculate distance between two locations
    func distance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2) / 1609.34 // Convert meters to miles
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        reverseGeocode(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = "Failed to get location: \(error.localizedDescription)"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            requestLocation()
        }
    }
}

// MARK: - Temporary Location Model (for trainers)
struct TemporaryLocation: Codable {
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    var startDate: Date
    var endDate: Date?
    var notes: String?
    
    var isActive: Bool {
        let now = Date()
        if let endDate = endDate {
            return now >= startDate && now <= endDate
        }
        return now >= startDate
    }
}
