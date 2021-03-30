//
//  SkyPickerAPIClient.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation
import Alamofire

struct SkyPickerAPIClient {
    static func getPopularFlights(onCompletion: @escaping (APIResponse<[Flight]>) -> ()) {
        AF.request(SkyPickerAPIConfiguration.getPopularFlights)
            .responseDecodable(of: FlightResponse.self) { response in

            guard let responseValue = response.value else {
                onCompletion(APIResponse.fail("Network Error"))
                return
            }
            
            guard responseValue.errors == nil else {
                onCompletion(APIResponse.fail(responseValue.errors?.first?.errors.first ?? "Network Error"))
                return
            }
            
            if let flights = responseValue.flights {
                onCompletion(APIResponse.success(flights))
            } else {
                onCompletion(APIResponse.fail("Can't parse response"))
            }
        }
    }
}
