//
//  Address.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

struct Address: Codable, Equatable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

struct Geo: Codable, Equatable {
    let lat: String?
    let lng: String?
}
