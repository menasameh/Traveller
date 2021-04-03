//
//  Location.swift
//  Traveller
//
//  Created by Mina Sameh on 3/4/21.
//

import Foundation

struct Location: Codable {
    let city: City

    enum CodingKeys: String, CodingKey {
        case city
    }
}

struct City: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id
    }
}
