//
//  CoreDataTest.swift
//  TravellerTests
//
//  Created by Mina Sameh on 5/4/21.
//

import XCTest
import CoreData
@testable import Traveller

class CoreDataTest: XCTestCase {
    var flightsService: FlightsService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
      super.setUp()
      coreDataStack = TestCoreDataStack()
        flightsService = FlightsService(
        managedObjectContext: coreDataStack.mainContext,
        coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
      super.tearDown()
        flightsService = nil
      coreDataStack = nil
    }
    
    func testLoadEmptyData() {
        // action
        let savedFlights = flightsService.getAllSavedFlights()
        
        // assert
        XCTAssertEqual(savedFlights.count, 0)
    }
    
    func testSaveFlights() {
        // prepare
        flightsService.saveFlightCities(TestUtils.getFlights(cities: ["1"]), on: Date().add(days: -1))

        
        // action
        let savedFlights = flightsService.getAllSavedFlights()
        
        // assert
        XCTAssertEqual(savedFlights.count, 1)
    }
    
    func testSavedDates() {
        // prepare
        flightsService.saveFlightCities(TestUtils.getFlights(cities: ["1"]), on: Date().add(days: -1))
        flightsService.saveFlightCities(TestUtils.getFlights(cities: ["2"]), on: Date())

        
        // action
        let savedFlights = flightsService.getAllSavedFlights()
        let todaysFlights = savedFlights.filter { $0.date?.isToday() ?? false }.map { $0.city }
        let otherFlights = savedFlights.filter { !($0.date?.isToday() ?? false) }.map { $0.city }

        
        // assert
        XCTAssertEqual(savedFlights.count, 2)
        XCTAssertEqual(todaysFlights.count, 1)
        XCTAssertEqual(otherFlights.count, 1)
    }
    
    func testRemoveFlights() {
        // NSBatchRemoveRequest is not supported for in memory container
    }
    
}
