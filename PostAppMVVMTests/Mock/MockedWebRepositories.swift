//
//  MockedWebRepositories.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import Combine
@testable import PostAppMVVM

class TestWebRepository: WebRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
    let bgQueue = DispatchQueue(label: "test")
}

// MARK: - CountriesWebRepository

final class MockedWebPostRepository: TestWebRepository, Mock, WebPostsRepository {
    enum Action: Equatable {
        case loadPost(id: Int64)
        case loadPosts
        case loadUser(id: Int64)
        case loadUsers
    }
    var actions = MockActions<Action>(expected: [])

    var postsResponse: Result<[FullPost], Error> = .failure(MockError.valueNotSet)
    let postResponse: Result<FullPost, Error>  = .success(FullPost.mockedData[0])
    let userInfoResponse: Result<UserInfo, Error> = .success(UserInfo.mockUser)
    let usersInfoResponse: Result<[UserInfo], Error> = .success([UserInfo.mockUser])

    func loadPost(with id: Int64) -> AnyPublisher<FullPost, Error> {
        register(.loadPost(id: id))
        return postResponse.publish()
    }

    func loadPosts() -> AnyPublisher<[FullPost], Error> {
        register(.loadPosts)
        return postsResponse.publish()
    }

    func loadUser(id: Int64) -> AnyPublisher<UserInfo, Error> {
        register(.loadUser(id: id))
        return userInfoResponse.publish()
    }

    func loadUsers(userIds: Set<Int64>) -> AnyPublisher<[UserInfo], Error> {
        register(.loadUsers)
        return usersInfoResponse.publish()
    }
}
