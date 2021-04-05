//
//  TestUtils.swift
//  TravellerTests
//
//  Created by Mina Sameh on 5/4/21.
//

@testable import Traveller

struct TestUtils {
    static func getFlights(cities: [String]) -> [Flight] {
        return cities.map { Flight(cityTo: $0) }
    }
}
