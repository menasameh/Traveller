//
//  SkyPickerAPIConfiguration.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Foundation
import Alamofire

enum SkyPickerAPIConfiguration: APIConfiguration {
    
    case getPopularFlights
  
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getPopularFlights:
            return .get
        }
    }
    // MARK: - Parameters
     var parameters: RequestParams {
        var parameter: [String : String] = [
            "partner" : "picky",
            "v" : "3"
        ]

        switch self {
        case .getPopularFlights:
            let startDate = Date()
            let endDate = startDate.addingTimeInterval(60 * 60 * 24 * 7)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            parameter["flyFrom"] = "49.2-16.61-250km"
            parameter["to"] = "anywhere"
            parameter["dateFrom"] = formatter.string(from: startDate)
            parameter["dateTo"] = formatter.string(from: endDate)
            parameter["oneforcity"] = "1"
            parameter["sort"] = "popularity"
            parameter["asc"] = "0"
            parameter["limit"] = "45"

            return .url(parameter)
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getPopularFlights:
            return "/flights"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
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
    
    func request() throws -> DataRequest {
        AF.request(self)
    }
}
