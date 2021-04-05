//
//  FlightsService.swift
//  Traveller
//
//  Created by Mina Sameh on 5/4/21.
//

import Foundation
import CoreData

public class FlightsService {
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
      self.managedObjectContext = managedObjectContext
      self.coreDataStack = coreDataStack
    }
    
    func getAllSavedFlights() -> [FlightDstCity] {
        do {
            return try managedObjectContext.fetch(FlightDstCity.fetchRequest())
        } catch {
            // TODO: handle errors
            return []
        }
    }
    
    func saveFlightCities(_ flights: [Flight], on date: Date) {
        var flightDsts: [FlightDstCity] = []
        
        for flight in flights {
            let flightDst = FlightDstCity(context: managedObjectContext)
            flightDst.city = flight.cityTo
            flightDst.date = date
            flightDsts.append(flightDst)
        }
        
        coreDataStack.saveContext(managedObjectContext)
    }
    
    public func removeFlightCities(before date: Date) {
        let fetch: NSFetchRequest<NSFetchRequestResult> = FlightDstCity.fetchRequest()
        fetch.predicate = NSPredicate(format: "date < %@", date as NSDate)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)

        try? managedObjectContext.execute(request)
        coreDataStack.saveContext(managedObjectContext)
    }

}
