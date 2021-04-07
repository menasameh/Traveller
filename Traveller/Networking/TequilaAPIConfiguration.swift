//
//  TequilaAPIConfiguration.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Foundation
import CoreLocation
import Alamofire

enum TequilaAPIConfiguration: APIConfiguration {
    private static let RESULT_LIMIT = 50
    
    case getPopularFlights(FlightRequest)
    case getCityId(LocationRequest)
  
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getPopularFlights:
            return .get
        case .getCityId:
            return .get
        }
    }
    // MARK: - Parameters
     var parameters: RequestParams {
        switch self {
        case .getPopularFlights(let flightRequest):
            var parameter: [String : String] = [:]

            parameter["fly_from"] = "\(flightRequest.location.latitude)-\(flightRequest.location.longitude)-250km"
            parameter["date_from"] = flightRequest.startDate.toString()
            parameter["date_to"] = flightRequest.endDate.toString()
            parameter["one_for_city"] = "1"
            parameter["sort"] = "popularity"
            parameter["asc"] = "0"
            parameter["limit"] = "\(TequilaAPIConfiguration.RESULT_LIMIT)"
            return .url(parameter)
        case .getCityId(let locationReequest):
            return .url(["id" : locationReequest.airportId])
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getPopularFlights:
            return "/v2/search"
        case .getCityId:
            return "/locations/id"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        let apiKey = Constants.ProductionServer.apiKey!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(apiKey, forHTTPHeaderField: HTTPHeaderField.apiKey.rawValue)
        
        // Parameters
        switch parameters {
            
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
                let queryParams = params.map { pair  in
                    return URLQueryItem(name: pair.key, value: "\(pair.value)")
                }
                var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
                components?.queryItems = queryParams
                urlRequest.url = components?.url
        }
            return urlRequest
    }
}
