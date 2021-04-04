//
//  Flight.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation

struct Flight: Codable {
    let id: String
    let duration: Duration
    let flyFrom: String
    let flyTo: String
    let cityTo: String
    let distance: Double
    let price: Int
    let availability: Availability
    let conversion: Conversion
    let bookingToken: String
    let route: [Route]
    let departureTime: String

    enum CodingKeys: String, CodingKey {
        case id, duration
        case flyTo, flyFrom, cityTo, distance
        case price, availability, conversion, route
        case bookingToken = "booking_token"
        case departureTime = "local_departure"
    }
}

// MARK: - Duration
struct Duration: Codable {
    let departure, durationReturn, total: Int

    enum CodingKeys: String, CodingKey {
        case departure
        case durationReturn = "return"
        case total
    }
}

// MARK: - Availability
struct Availability: Codable {
    let seats: Int?
}

// MARK: - Country
struct Country: Codable {
    let code, name: String
}

// MARK: - Route
struct Route: Codable {
    let id: String
    let flyTo: String
    

    enum CodingKeys: String, CodingKey {
        case id, flyTo
    }
}

// MARK: - Conversion
struct Conversion: Codable {
    let eur: Int

    enum CodingKeys: String, CodingKey {
        case eur = "EUR"
    }
}
