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
        // TODO: Check authorization state
//        locationManager.authorizationStatus

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
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
