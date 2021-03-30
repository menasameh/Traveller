//
//  ErrorResponse.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation

struct ErrorResponse: Codable {
    let param: String
    let errors: [String]
}
