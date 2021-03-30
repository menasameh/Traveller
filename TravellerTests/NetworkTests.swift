//
//  NetworkTests.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import XCTest
@testable import Traveller

class NetworkTests: XCTestCase {

    func testGetPopularOffers() throws {
        let expectation = self.expectation(description: "waitForApiCall")
        
        SkyPickerAPIClient.getPopularFlights { response in
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
}
