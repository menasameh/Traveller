//
//  FlightsTableViewController.swift
//  Traveller
//
//  Created by Mina Sameh on 31/3/21.
//

import UIKit

class FlightsTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    var flightsViewModel = FlightsViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        let nib = UINib(nibName: FlightTableViewCell.identefier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FlightTableViewCell.identefier)
        tableView.dataSource = self
        tableView.delegate = self
        
        title = "popular_flights_screen_title".localized()

        flightsViewModel.listener = self
        flightsViewModel.requestPopularFlights()
    }
}

// MARK: - Table view delegate & data source
extension FlightsTableViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightsViewModel.getFlightCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlightTableViewCell.identefier, for: indexPath) as? FlightTableViewCell ?? FlightTableViewCell()
        cell.setupCell(for: flightsViewModel.getFlight(at: indexPath.row), api: flightsViewModel.kiwiApi)
        return cell
    }
}

extension FlightsTableViewController: FlightsViewModelListener {
    func requestFlightsFailed(error: String) {
        errorMessage.text = error
        loadingView.isHidden = true
        errorView.isHidden = false
        emptyView.isHidden = true
    }
    
    func requestFlightsStarted() {
        loadingView.isHidden = false
        errorView.isHidden = true
        emptyView.isHidden = true
    }
    
    func requestFlightsSucceeded() {
        loadingView.isHidden = true
        errorView.isHidden = true
        if flightsViewModel.getFlightCount() == 0 {
            emptyView.isHidden = false
        }
        tableView.reloadData()
    }
    
    func requestFlightsFailed() {
        loadingView.isHidden = true
        errorView.isHidden = false
        emptyView.isHidden = true
    }
}
