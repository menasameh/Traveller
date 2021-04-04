//
//  HomeViewController.swift
//  Traveller
//
//  Created by Mina Sameh on 4/4/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    // called on `Primary action triggered`, aka keyboard button press
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
