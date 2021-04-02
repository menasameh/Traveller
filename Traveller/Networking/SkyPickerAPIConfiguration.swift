//
//  SkyPickerAPIConfiguration.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Foundation
import CoreLocation
import Alamofire

enum SkyPickerAPIConfiguration: APIConfiguration {
    private static let RESULT_LIMIT = 50
    
    case getPopularFlights(FlightRequest)
  
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getPopularFlights:
            return .get
        }
    }
    // MARK: - Parameters
     var parameters: RequestParams {
        switch self {
        case .getPopularFlights(let flightRequest):
            var parameter: [String : String] = [:]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            parameter["fly_from"] = "\(flightRequest.location.latitude)-\(flightRequest.location.longitude)-250km"
            parameter["date_from"] = formatter.string(from: flightRequest.startDate)
            parameter["date_to"] = formatter.string(from: flightRequest.endDate)
            parameter["one_for_city"] = "1"
            parameter["sort"] = "popularity"
            parameter["asc"] = "0"
            parameter["limit"] = "\(SkyPickerAPIConfiguration.RESULT_LIMIT)"
            return .url(parameter)
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getPopularFlights:
            return "/search"
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
        urlRequest.setValue(apiKey, forHTTPHeaderField: "apikey")
        
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
