//
//  KiwiAPIConfiguration.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import Alamofire
import AlamofireImage

class KiwiAPIConfiguration {
    private let URL_FORMAT = "https://images.kiwi.com/photos/600x330/%@.jpg"
    let imageCache: AutoPurgingImageCache
    
    init() {
        imageCache = AutoPurgingImageCache()
    }
    
    func getDestinationImage(for destinationId: String, onCompletion: @escaping (APIResponse<UIImage>) -> () ) throws {
        if let image = imageCache.image(withIdentifier: destinationId) {
            onCompletion(APIResponse.success(image))
            return
        }
        
        APIClient.getCityId(for: LocationRequest(airportId: destinationId)) { [weak self] response in
            guard let strongSelf = self else { return }
            guard case let .success(cityId) = response else {
                onCompletion(APIResponse.fail("image_load_error".localized()))
                return
            }

            AF.request(String(format: strongSelf.URL_FORMAT, arguments: [cityId])).responseImage { [weak self] response in
                if case .success(let image) = response.result {
                    self?.imageCache.add(image, withIdentifier: destinationId)
                    onCompletion(APIResponse.success(image))
                } else {
                    onCompletion(APIResponse.fail("image_load_error".localized()))
                }
            }
        }
    }
}
