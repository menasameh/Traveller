//
//  Bundle+getInfoValue.swift
//  Traveller
//
//  Created by Mina Sameh on 2/4/21.
//

import Foundation
extension Bundle {
    static func getInfoStringValue(for key: String) -> String? {
        Bundle.main.infoDictionary?[key] as? String
    }
}
