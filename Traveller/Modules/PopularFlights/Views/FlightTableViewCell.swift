//
//  FlightTableViewCell.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    static public let identefier = "FlightTableViewCell"

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    private var destinationCityId: String = ""

    // TODO: refactor Flight object sent to view to have direct values
    func setupCell(for flight: Flight) {
        // Save destinationCityId to check once the image is received, is it the same or it has changed
        destinationCityId = flight.mapIdto
        try? KiwiAPIConfiguration.getDestinationImage(for: flight.mapIdto) { [weak self] response in
            guard let strongSelf = self, strongSelf.destinationCityId == flight.mapIdto else {
                // view has been deallocated, or cell was reused for another city
                return
            }

            switch response {
            case .success(let image):
                strongSelf.backgroundImage.image = image
            case .fail:
                // TODO: add fallback image
                strongSelf.backgroundImage.image = UIImage(named: "fallback")
            }
        }
        destinationName.text = flight.cityTo
        price.text = Conversion.CodingKeys.eur.rawValue + " " + String(flight.price)
    }
    
}
