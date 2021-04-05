//
//  SkyPickerAPIClient.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation
import Alamofire

struct APIClient {
    static func getPopularFlights(for flightRequest: FlightRequest, onCompletion: @escaping (APIResponse<[Flight]>) -> ()) {
        AF.request(TequilaAPIConfiguration.getPopularFlights(flightRequest))
            .responseDecodable(of: FlightResponse.self) { response in
            guard let responseValue = response.value else {
                onCompletion(APIResponse.fail("Network Error"))
                return
            }

            guard responseValue.error == nil else {
                onCompletion(APIResponse.fail(responseValue.error ?? "Network Error"))
                return
            }

            if let flights = responseValue.flights {
                onCompletion(APIResponse.success(flights))
            } else {
                onCompletion(APIResponse.fail("Can't parse response"))
            }
        }
    }
    
    static func getCityId(for locationRequest: LocationRequest, onCompletion: @escaping (APIResponse<String>) -> ()) {
        AF.request(TequilaAPIConfiguration.getCityId(locationRequest))
            .responseDecodable(of: LocationResponse.self) { response in
            guard let responseValue = response.value else {
                onCompletion(APIResponse.fail("Network Error"))
                return
            }
                
            if let cityId = responseValue.locations?.first?.city.id {
                onCompletion(APIResponse.success(cityId))
            } else {
                onCompletion(APIResponse.fail("Can't parse response"))
            }
        }
    }
}
