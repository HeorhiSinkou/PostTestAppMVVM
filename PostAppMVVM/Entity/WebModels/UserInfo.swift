//
//  UserInfo.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

struct UserInfo: Codable, Equatable {
    init(id: Int64,
         name: String? = nil,
         username: String? = nil,
         email: String? = nil,
         address: Address? = nil,
         phone: String? = nil,
         website: String? = nil,
         company: Company? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }

    let id: Int64
    let name: String?
    let username: String?
    let email: String?
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
}
