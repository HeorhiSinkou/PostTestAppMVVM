//
//  Post.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

struct Post: Codable, Equatable, Identifiable {
    let userId: Int64
    let id: Int64
    let title: String?
    let body: String?
}
