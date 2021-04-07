//
//  LocationManager.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import CoreLocation

protocol LocationManagerDelegate: NSObject {
    func locationDidInitialize()
    func locationDidUpdate()
    func locationIsNotEnabled(error: LocationError)
}

class LocationManager: NSObject {
    let locationManager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D?
    private(set) var locationServiceDidInitialize = false
    
    weak var delegate: LocationManagerDelegate?
    
    private func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationService() {
        requestPermissions()
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    delegate?.locationIsNotEnabled(error: .locationPermissionNotGranted)
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                @unknown default:
                    delegate?.locationIsNotEnabled(error: .unknownError)
            }
        } else {
            delegate?.locationIsNotEnabled(error: .locationServicesNotEnabled)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lastLocation = locValue
        if !locationServiceDidInitialize {
            locationServiceDidInitialize = true
            delegate?.locationDidInitialize()
        }
        delegate?.locationDidUpdate()
    }
}
