//
//  Int+toReadbleDuration.swift
//  Traveller
//
//  Created by Mina Sameh on 4/4/21.
//

import Foundation

extension Int {
    func toReadbleDuration() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short

        return formatter.string(from: TimeInterval(self))
    }
}
