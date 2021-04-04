//
//  FlightCard.swift
//  Traveller
//
//  Created by Mina Sameh on 4/4/21.
//

import Foundation

struct FlightCard {
    let duration: String
    let city: String
    let airport: String
    let distance: String
    let price: Int
    let currency: String
    let startDate: String
    var route: [String]
    
    var priceTag: String {
        "\(currency) \(price)"
    }
    
    var stops: String {
        if route.count == 1 {
            return "Direct flight!"
        } else {
            return "\(route.count) Stops"
        }
    }
    
    init(_ flight: Flight) {
//        duration = flight.duration
        city = flight.cityTo
        airport = flight.flyTo
//        distance = flight.distance
        price = flight.price
        currency = Conversion.CodingKeys.eur.rawValue
        
        route = [flight.flyFrom]
        route.append(contentsOf: flight.route.map { $0.flyTo })
        
        if let date = Date.fromISO(string: flight.departureTime) {
            startDate = date.toReadbleString()
        } else {
            startDate = ""
        }
        
        duration = ""
        distance = ""
    }
}
