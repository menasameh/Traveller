//
//  LocationResponse.swift
//  Traveller
//
//  Created by Mina Sameh on 3/4/21.
//

import Foundation

struct LocationResponse: Codable {
    let locations: [Location]?
    
    enum CodingKeys: String, CodingKey {
        case locations
    }
}
