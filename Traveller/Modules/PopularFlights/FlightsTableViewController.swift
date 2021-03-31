//
//  FlightsTableViewController.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import UIKit

class FlightsTableViewController: UITableViewController {

    var flightsViewModel = FlightsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        let nib = UINib(nibName: FlightTableViewCell.identefier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FlightTableViewCell.identefier)

        flightsViewModel.listener = self
        flightsViewModel.requestPopularFlights()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightsViewModel.getFlightCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.identefier, for: indexPath) as? FlightTableViewCell ?? FlightTableViewCell()
        cell.setupCell(for: flightsViewModel.getFlight(at: indexPath.row))
        return cell
    }
}

extension FlightsTableViewController: FlightsViewModelListener {
    func requestFlightsStarted() {
        
    }
    
    func requestFlightsSucceeded() {
        tableView.reloadData()
    }
    
    func requestFlightsFailed() {
        
    }
}
