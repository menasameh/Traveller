//
//  FlightDstCity+CoreDataClass.swift
//  Traveller
//
//  Created by Mina Sameh on 2/4/21.
//
//

import UIKit
import CoreData

@objc(FlightDstCity)
public class FlightDstCity: NSManagedObject {
    
    private class func getContext() -> NSManagedObjectContext? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    class func getAllSavedFlights() -> [FlightDstCity] {
        guard let context = getContext() else {
            return []
        }
        
        do {
            return try context.fetch(FlightDstCity.fetchRequest())
        } catch {
            // TODO: handle errors
            return []
        }
    }
    
    class func saveFlightCities(_ flights: [Flight], on date: Date) {
        guard let context = getContext() else {
            return
        }
        
        var flightDsts: [FlightDstCity] = []
        
        for flight in flights {
            let flightDst = FlightDstCity(context: context)
            flightDst.city = flight.cityTo
            flightDst.date = date
            flightDsts.append(flightDst)
        }

        // TODO: handle errors
        try? context.save()
    }

    class func removeFlightCities(before date: Date) {
        guard let context = getContext() else {
            return
        }
        
        let fetch: NSFetchRequest<NSFetchRequestResult> = FlightDstCity.fetchRequest()
        fetch.predicate = NSPredicate(format: "date < %@", date as NSDate)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)

        // TODO: handle errors
        try? context.execute(request)
    }
}
