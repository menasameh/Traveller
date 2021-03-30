//
//  APIConstants.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation
import Alamofire

struct Constants {
    struct ProductionServer {
        static let baseURL = "https://api.skypicker.com"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
}

enum ContentType: String {
    case json = "Application/json"
}

enum RequestParams {
    case body(_:Parameters)
    case url(_:Parameters)
}
