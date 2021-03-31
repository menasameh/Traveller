//
//  KiwiAPIConfiguration.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Alamofire
import AlamofireImage

struct KiwiAPIConfiguration {
    static private let urlFormat = "https://images.kiwi.com/photos/600x330/%@.jpg"
    
    static func getDestinationImage(for destinationId: String, onCompletion: @escaping (APIResponse<UIImage>) -> () ) throws {
        AF.request(String(format: urlFormat, arguments: [destinationId])).responseImage { response in
            
            if case .success(let image) = response.result {
                onCompletion(APIResponse.success(image))
            } else {
                onCompletion(APIResponse.fail("Can't load image"))
            }
        }
    }
}
