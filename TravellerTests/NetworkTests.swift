//
//  NetworkTests.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import XCTest
@testable import Traveller

class NetworkTests: XCTestCase {

    func testGetPopularFlights() throws {
        let expectation = self.expectation(description: "waitForApiCall")
        
        APIClient.getPopularFlights { response in
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
        
        try? KiwiAPIConfiguration.getDestinationImage(for: "london_gb") { response in
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
        
        try? KiwiAPIConfiguration.getDestinationImage(for: "not_found") { response in
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
    
    func testGetImageForFlight() {
        let expectation = self.expectation(description: "waitForApiCall")
        
        APIClient.getPopularFlights { response in
            if case let .success(flights) = response {
                if let destinationUrl = flights.first?.mapIdto {
                    try? KiwiAPIConfiguration.getDestinationImage(for: destinationUrl) { response in
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
