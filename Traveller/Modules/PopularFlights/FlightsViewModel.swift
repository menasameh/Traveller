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
    private static let KEEP_DESTINATION_HISTORY = 1
    
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
                self?.filter(apiFlights: flights)
            case .fail(let error):
                self?.listener?.requestFlightsFailed()
                // TODO: Display error
                print(error)
            }
        }
    }
    
    private func filter(apiFlights allFlights: [Flight]) {
        FlightDstCity.removeFlightCities(before: Date().add(days: -FlightsViewModel.KEEP_DESTINATION_HISTORY))
        let savedFlights = FlightDstCity.getAllSavedFlights()
        filter(apiFlights: allFlights, savedFlights: savedFlights)
    }
    
    private func filter(apiFlights allFlights: [Flight], savedFlights: [FlightDstCity]) {
        let todaysFlights = savedFlights.filter { $0.date?.isToday() ?? false }.map { $0.city }
        let otherFlights = savedFlights.filter { !($0.date?.isToday() ?? false) }.map { $0.city }

        if !todaysFlights.isEmpty {
            // there are already saved flights for today, we need to show the same destinations
            var filterFlights = allFlights.filter { todaysFlights.contains($0.cityTo) }
            // if a trip is not available anymore the count of flight will be less than needed
            if filterFlights.count < FlightsViewModel.FLIGHTS_COUNT_TO_SHOW {
                // calculate the needed amount of additional flights
                let neededCount = FlightsViewModel.FLIGHTS_COUNT_TO_SHOW - filterFlights.count
                let additionalFlights = allFlights.filter { otherFlights.contains($0.cityTo) }.prefix(neededCount)
                // add additional flights to the results
                filterFlights.append(contentsOf: additionalFlights)
                // add additional flights to the today's flights in the database
                FlightDstCity.saveFlightCities(Array(additionalFlights), on: Date())
            }
            // ensure that we return the exact count and no more than that
            flights = Array(filterFlights.prefix(FlightsViewModel.FLIGHTS_COUNT_TO_SHOW))
        } else {
            // No flights saved for today, choose some and save them into the database
            let availableFlights = allFlights.filter { !otherFlights.contains($0.cityTo) }
            let choosenFlights = Array(availableFlights.prefix(FlightsViewModel.FLIGHTS_COUNT_TO_SHOW))
            FlightDstCity.saveFlightCities(choosenFlights, on: Date())
            flights = choosenFlights
        }
        listener?.requestFlightsSucceeded()
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
