//
//  FlightsViewModel.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Foundation
import CoreLocation

protocol FlightsViewModelListener: NSObject {
    func requestFlightsStarted()
    func requestFlightsSucceeded()
    func requestFlightsFailed()
}

class FlightsViewModel: NSObject {
    private static let SEARCH_DURATION: TimeInterval = 60 * 60 * 24 * 7
    
    private var flights: [Flight] = []
    weak var listener: FlightsViewModelListener?
    var locationManager = LocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestPopularFlights() {
        listener?.requestFlightsStarted()
        
        guard locationManager.locationServiceDidInitialize else {
            locationManager.startLocationService()
            return
        }
        
        if let location = locationManager.lastLocation {
            requestPopularFlights(for: location)
        }
    }
    
    func requestPopularFlights(for location: CLLocationCoordinate2D) {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(FlightsViewModel.SEARCH_DURATION)
        let flightRequest = FlightRequest(startDate: startDate, endDate: endDate, location: location)
        
        APIClient.getPopularFlights(for: flightRequest) { [weak self] response in
            switch response {
            case .success(let flights):
                self?.flights = Array(flights.prefix(5))
                self?.listener?.requestFlightsSucceeded()
            case .fail(let error):
                self?.listener?.requestFlightsFailed()
                // TODO: Display error
                print(error)
            }
        }
    }
    
    func getFlight(at index: Int) -> Flight {
        return flights[index]
    }
    
    func getFlightCount() -> Int {
        return flights.count
    }
}

extension FlightsViewModel: LocationManagerDelegate {
    func locationDidInitialize() {
        if let location = locationManager.lastLocation {
            requestPopularFlights(for: location)
        }
    }
    
    func locationDidUpdate() { /* Not used */ }
}
