//
//  FlightResponse.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation

struct FlightResponse: Codable {
    let id: String?
    let error: String?
    let flights: [Flight]?
    
    enum CodingKeys: String, CodingKey {
        case id = "search_id"
        case error = "message"
        case flights = "data"
    }
}
