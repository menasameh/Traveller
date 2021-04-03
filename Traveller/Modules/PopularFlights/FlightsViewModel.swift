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
    // SEARCH_DURATION is in days after the start date
    private static let SEARCH_DURATION = 7
    private static let FLIGHTS_COUNT_TO_SHOW = 5
    // KEEP_DESTINATION_HISTORY is in days to keep the destinations shown on the app saved in the DB
    private static let KEEP_DESTINATION_HISTORY = 7
    
    private var flights: [Flight] = []
    weak var listener: FlightsViewModelListener?
    var locationManager = LocationManager()
    var kiwiApi = KiwiAPIConfiguration()
    
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
        let endDate = startDate.add(days: FlightsViewModel.SEARCH_DURATION)
        let flightRequest = FlightRequest(startDate: startDate, endDate: endDate, location: location)
        
        APIClient.getPopularFlights(for: flightRequest) { [weak self] response in
            switch response {
            case .success(let flights):
                self?.flights = Array(flights.prefix(FlightsViewModel.FLIGHTS_COUNT_TO_SHOW))
                self?.listener?.requestFlightsSucceeded()
            case .fail(let error):
                self?.listener?.requestFlightsFailed()
                // TODO: Display error
                print(error)
            }
        }
    }
    
    private func filter(flights allFlights: [Flight]) {
        FlightDstCity.removeFlightCities(before: Date().add(days: -FlightsViewModel.KEEP_DESTINATION_HISTORY))
        let savedFlights = FlightDstCity.getAllSavedFlights()
        let todaysFlights = savedFlights.filter { $0.date?.isToday() ?? false }.map { $0.city }
        let otherFlights = savedFlights.filter { !($0.date?.isToday() ?? false) }

        if !todaysFlights.isEmpty {
            // show same destinations
            let filterFlights = allFlights.filter { todaysFlights.contains($0.cityTo) }
            if filterFlights.count == FlightsViewModel.FLIGHTS_COUNT_TO_SHOW {
                flights = filterFlights
            } else {
                
            }
        } else {
            
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
