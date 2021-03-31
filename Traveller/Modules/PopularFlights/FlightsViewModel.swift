//
//  FlightsViewModel.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Foundation

protocol FlightsViewModelListener: NSObject {
    func requestFlightsStarted()
    func requestFlightsSucceeded()
    func requestFlightsFailed()
}

class FlightsViewModel {
    private var flights: [Flight] = []
    weak var listener: FlightsViewModelListener?
    
    func requestPopularFlights() {
        listener?.requestFlightsStarted()
        APIClient.getPopularFlights { [weak self] response in
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
