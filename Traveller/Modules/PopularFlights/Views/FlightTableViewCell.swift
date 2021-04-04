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
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    private var destinationCityId: String = ""
    
    override func awakeFromNib() {
        // Add rounded corners to the card view
        card.layer.cornerRadius = cornerRadius
        
        // Add Shadow to the card view
        card.layer.shadowColor = shadowColor
        card.layer.shadowOpacity = shadowOpacity
        card.layer.shadowOffset = shadowOffset
        card.layer.shadowRadius = shadowRadius
        card.layer.shouldRasterize = true
    }

    func setupCell(for flight: FlightCard, api: KiwiAPIConfiguration) {
        requestImage(for: flight.airport, with: api)
        
        destinationName.text = flight.city
        price.text = flight.priceTag
        date.text = flight.startDate
        stops.text = flight.stops
        duration.text = flight.duration
    }
    
    private func requestImage(for city: String, with api: KiwiAPIConfiguration) {
        // Save destinationCityId to check once the image is received, is it the same or it has changed
        destinationCityId = city

        try? api.getDestinationImage(for: city) { [weak self] response in
            guard let strongSelf = self, strongSelf.destinationCityId == city else {
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
    }
    
    // MARK: - design constants
    let cornerRadius: CGFloat = 10
    let shadowColor = UIColor.black.cgColor
    let shadowOpacity: Float = 0.3
    let shadowOffset = CGSize.zero
    let shadowRadius: CGFloat = 5
}
