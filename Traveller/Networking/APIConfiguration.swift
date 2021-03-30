//
//  APIConfiguration.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}
