//
//  PostApiController.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//


import Foundation

enum PostApiController {
    case posts
    case postDetail(id: Int64)
    case user(id: Int64)
}

extension PostApiController: APIController {
    var path: String {
        switch self {
        case .postDetail(let id): return "/posts/\(id)"
        case .posts: return "/posts"
        case .user(let id): return "/users/\(id)"
        }
    }

    var method: Method {
        switch self {
        case .postDetail: return .get
        case .posts: return .get
        case .user: return .get
        }
    }

    var headers: [String : String]? {
        switch self {
        case .postDetail: return ["Accept": "application/json"]
        case .posts: return ["Accept": "application/json"]
        case .user: return ["Accept": "application/json"]
        }
    }

    func body() throws -> Data? {
        switch self {
        case .postDetail: return nil
        case .posts: return nil
        case .user: return nil
        }
    }
}
