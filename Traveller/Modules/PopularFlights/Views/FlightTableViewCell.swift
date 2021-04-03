//
//  FlightTableViewCell.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    static public let identefier = "FlightTableViewCell"
    private let defaultDestinationImageName = "defaultDestinationImage"

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    private var destinationCityId: String = ""

    // TODO: refactor Flight object sent to view to have direct values
    func setupCell(for flight: Flight, api: KiwiAPIConfiguration) {
        // Save destinationCityId to check once the image is received, is it the same or it has changed
        destinationCityId = flight.flyTo
        
        try? api.getDestinationImage(for: flight.flyTo) { [weak self] response in
            guard let strongSelf = self, strongSelf.destinationCityId == flight.flyTo else {
                // view has been deallocated, or cell was reused for another city
                return
            }

            switch response {
            case .success(let image):
                strongSelf.backgroundImage.image = image
            case .fail:
                strongSelf.backgroundImage.image = UIImage(named: strongSelf.defaultDestinationImageName)
            }
        }
        
        destinationName.text = flight.cityTo
        price.text = Conversion.CodingKeys.eur.rawValue + " " + String(flight.price)
    }
    
}
