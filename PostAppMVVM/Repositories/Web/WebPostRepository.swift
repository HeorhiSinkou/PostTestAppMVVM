//
//  WebPostRepository.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import Foundation

protocol WebPostsRepository: WebRepository {
    func loadPost(with id: Int64) -> AnyPublisher<FullPost, Error>
    func loadPosts() -> AnyPublisher<[FullPost], Error>
    func loadUser(id: Int64) -> AnyPublisher<UserInfo, Error>
    func loadUsers(userIds: Set<Int64>) ->  AnyPublisher<[UserInfo], Error>
}

struct RealWebPostsRepository: WebPostsRepository {
    let session: URLSession
    let baseURL: String

    init(session: URLSession, baseURL: BaseURL) {
        self.session = session
        self.baseURL = baseURL.rawValue
    }

    func loadPost(with id: Int64) -> AnyPublisher<FullPost, Error> {
        return call(endpoint: PostApiController.postDetail(id: id))
    }

    func loadPosts() -> AnyPublisher<[FullPost], Error> {
        return call(endpoint: PostApiController.posts)
    }


    func loadUser(id: Int64) -> AnyPublisher<UserInfo, Error> {
        return call(endpoint: UserInfoApiController.user(id: id))
    }

    func loadUsers(userIds: Set<Int64>) ->  AnyPublisher<[UserInfo], Error> {
        Publishers
            .Sequence(sequence: userIds)
            .flatMap { id -> AnyPublisher<UserInfo, Error> in
                self.loadUser(id: id)
            }
            .eraseToAnyPublisher()
            .collect()
            .flatMap {
                Just<[UserInfo]>.withErrorType($0, Error.self)
            }
            .eraseToAnyPublisher()
    }
}
