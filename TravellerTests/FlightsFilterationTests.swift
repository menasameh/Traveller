//
//  FlightsFilterationTests.swift
//  TravellerTests
//
//  Created by Mina Sameh on 5/4/21.
//

import XCTest
import CoreData
@testable import Traveller

class FlightsFilterationTests: XCTestCase {
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
    
    func testNoSavedFlights() throws {
        // prepare
        let flights = getFlights(cities: ["1", "2", "3", "4", "5", "6"])
        let savedFlights = flightsService.getAllSavedFlights()
        let viewModel = FlightsViewModel()
        // action
        
        viewModel.filter(apiFlights: flights, savedFlights: savedFlights)
        
        // assert
        XCTAssertEqual(viewModel.getFlightCount(), 5)
        XCTAssertEqual(viewModel.getFlight(at: 0).city, "1")
        XCTAssertEqual(viewModel.getFlight(at: 4).city, "5")
    }
    
    func testSavedFlightsOtherDay() throws {
        // prepare
        flightsService.saveFlightCities(getFlights(cities: ["1"]), on: Date().add(days: -1))
        let flights = getFlights(cities: ["1", "2", "3", "4", "5", "6"])
        let savedFlights = flightsService.getAllSavedFlights()
        let viewModel = FlightsViewModel()
        // action
        
        viewModel.filter(apiFlights: flights, savedFlights: savedFlights)
        
        // assert
        XCTAssertEqual(viewModel.getFlightCount(), 5)
        XCTAssertEqual(viewModel.getFlight(at: 0).city, "2")
        XCTAssertEqual(viewModel.getFlight(at: 4).city, "6")
    }
    
    func testSavedFlightsSameDayFullCapacity() throws {
        // prepare
        flightsService.saveFlightCities(getFlights(cities: ["1", "2", "3", "4", "6"]), on: Date())
        let flights = getFlights(cities: ["1", "2", "3", "4", "5", "6"])
        let savedFlights = flightsService.getAllSavedFlights()
        let viewModel = FlightsViewModel()
        // action

        viewModel.filter(apiFlights: flights, savedFlights: savedFlights)
        
        // assert
        XCTAssertEqual(viewModel.getFlightCount(), 5)
        XCTAssertEqual(viewModel.getFlight(at: 0).city, "1")
        XCTAssertEqual(viewModel.getFlight(at: 1).city, "2")
        XCTAssertEqual(viewModel.getFlight(at: 2).city, "3")
        XCTAssertEqual(viewModel.getFlight(at: 3).city, "4")
        XCTAssertEqual(viewModel.getFlight(at: 4).city, "6")
    }
    
    func testSavedFlightsSameDayNotFullCapacity() throws {
        // prepare
        flightsService.saveFlightCities(getFlights(cities: ["6"]), on: Date())
        let flights = getFlights(cities: ["1", "2", "3", "4", "5", "6"])
        let savedFlights = flightsService.getAllSavedFlights()
        let viewModel = FlightsViewModel()
        // action

        viewModel.filter(apiFlights: flights, savedFlights: savedFlights)
        
        // assert
        XCTAssertEqual(viewModel.getFlightCount(), 5)
        XCTAssertEqual(viewModel.getFlight(at: 0).city, "6")
        XCTAssertEqual(viewModel.getFlight(at: 1).city, "1")
        XCTAssertEqual(viewModel.getFlight(at: 2).city, "2")
        XCTAssertEqual(viewModel.getFlight(at: 3).city, "3")
        XCTAssertEqual(viewModel.getFlight(at: 4).city, "4")
    }
    
    
    private func getFlights(cities: [String]) -> [Flight] {
        return cities.map { Flight(cityTo: $0) }
    }
}
