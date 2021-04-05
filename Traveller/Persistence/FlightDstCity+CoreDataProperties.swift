//
//  FlightDstCity+CoreDataProperties.swift
//  Traveller
//
//  Created by Mina Sameh on 5/4/21.
//
//

import Foundation
import CoreData


extension FlightDstCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightDstCity> {
        return NSFetchRequest<FlightDstCity>(entityName: "FlightDstCity")
    }

    @NSManaged public var city: String?
    @NSManaged public var date: Date?

}

extension FlightDstCity : Identifiable {

}
