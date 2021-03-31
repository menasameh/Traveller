//
//  UIImage+remoteImage.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import UIKit

extension UIImageView {
    func remoteImage(_ url: String, fallback: String) {
        try? KiwiAPIConfiguration.getDestinationImage(for: url) { [weak self] response in
            switch response {
            case .success(let image):
                self?.image = image
            case .fail:
                self?.image = UIImage(named: fallback)
            }
        }
    }
}
