//
//  APIResponse.swift
//  Traveller
//
//  Created by Mina Sameh on 30/3/21.
//

import Foundation

enum APIResponse<T> {
    case success(T)
    case fail(String)
}
