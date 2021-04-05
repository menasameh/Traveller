//
//  NetworkTests.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import XCTest
import CoreLocation
@testable import Traveller

class NetworkTests: XCTestCase {
    
    let kiwiApi = KiwiAPIConfiguration()
    
    private func getPopularFlightRequest() -> FlightRequest {
        let startDate = Date()
        let endDate = startDate.add(days: 5)
        let location = CLLocationCoordinate2D(latitude: 35.3, longitude: 34.3)
        
        return FlightRequest(startDate: startDate, endDate: endDate, location: location)
    }

    func testGetPopularFlights() throws {
        let expectation = self.expectation(description: "waitForApiCall")
        APIClient.getPopularFlights(for: getPopularFlightRequest()) { response in
            switch response {
            case .success(let flights):
                print(flights.count)
            case .fail(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetDestinationImage() {
        let expectation = self.expectation(description: "waitForApiCall")
        
        try? kiwiApi.getDestinationImage(for: "LHR") { response in
            switch response {
            case .success:
                print("Success")
            case .fail(let error):
                print(error)
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetDestinationImage_wrongImage_APIShouldFallBack() {
        let expectation = self.expectation(description: "waitForApiCall")
        
        try? kiwiApi.getDestinationImage(for: "not_found") { response in
            switch response {
            case .success:
                print("Success")
                XCTFail()
            case .fail(let error):
                print(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetImageForFlight() {
        let expectation = self.expectation(description: "waitForApiCall")
        
        APIClient.getPopularFlights(for: getPopularFlightRequest()) { [weak self] response in
            if case let .success(flights) = response {
                if let destinationUrl = flights.first?.flyTo {
                    try? self!.kiwiApi.getDestinationImage(for: destinationUrl) { response in
                        if case .success = response {
                            expectation.fulfill()
                        } else {
                            XCTFail()
                        }
                    }
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
