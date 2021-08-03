//
//  FullPost.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

struct FullPost: Codable, Equatable, Identifiable {
    let userId: Int64
    let id: Int64
    var title: String?
    var body: String?
    var userInfo: UserInfo?
}

extension FullPost {
    init(post: Post) {
        self.userId = post.userId
        self.id = post.id
        self.title = post.title
        self.body = post.body
    }

    mutating func update(with userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}

// MARK: - for preview
extension FullPost {
    static let mockedData: [FullPost] = [
        FullPost(userId: 1, id: 1, title: "First post", body: "First post body", userInfo: UserInfo(id: 1, username: "First name", company: Company(name: "First company", catchPhrase: "", bs: ""))),
        FullPost(userId: 1, id: 2, title: "Second post", body: "Second post body", userInfo: UserInfo(id: 2, username: "Second name", company: Company(name: "Second company", catchPhrase: "", bs: ""))),
        FullPost(userId: 1, id: 3, title: "Third post", body: "Third post body", userInfo: UserInfo(id: 3, username: "Third name", company: Company(name: "Third company", catchPhrase: "", bs: "")))
    ]
}
