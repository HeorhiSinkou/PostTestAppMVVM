//
//  WebUserRepository.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import Foundation

protocol WebUserRepository: WebRepository {
    func loadUser(id: Int64) -> AnyPublisher<UserInfo, Error>
}

struct RealWebUserRepository: WebUserRepository {
    let session: URLSession
    let baseURL: String

    init(session: URLSession, baseURL: BaseURL) {
        self.session = session
        self.baseURL = baseURL.rawValue
    }

    func loadUser(id: Int64) -> AnyPublisher<UserInfo, Error> {
        return call(endpoint: UserInfoApiController.user(id: id))
    }
}
