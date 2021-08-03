//
//  UserInfoApiController.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

enum UserInfoApiController {
    case user(id: Int64)
}

extension UserInfoApiController: APIController {
    var path: String {
        switch self {
        case .user(let id): return "/users/\(id)"
        }
    }

    var method: Method {
        switch self {
        case .user: return .get
        }
    }

    var headers: [String : String]? {
        switch self {
        case .user: return ["Accept": "application/json"]
        }
    }

    func body() throws -> Data? {
        switch self {
        case .user: return nil
        }
    }
}

