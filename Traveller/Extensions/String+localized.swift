//
//  String+localized.swift
//  Traveller
//
//  Created by Mina Sameh on 7/4/21.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
