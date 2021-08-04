//
//  MockedDBRepositories.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import Combine
@testable import PostAppMVVM

final class MockedDBPostRepository: Mock, DBPostsRepository {
    enum Action: Equatable {
        case hasLoadedPosts
        case store(posts: [FullPost])
        case store(userInfoList: [UserInfo])
        case fetch
        case fetchSinglePost(withId: Int64)
    }
    var actions = MockActions<Action>(expected: [])

    var hasLoadedPostResult: Result<Bool, Error> = .success(true)
    var storePostsResult: Result<Void, Error> = .success(())
    var storeUserInfoListResult: Result<Void, Error> = .success(())
    var fetchPostsResult: Result<LazyList<FullPost>, Error> = .success(FullPost.mockedData.lazyList)
    var fetchSinglePostResult: Result<FullPost, Error> = .failure(MockError.valueNotSet)

    func store(posts: [FullPost]) -> AnyPublisher<Void, Error> {
        register(.store(posts: posts))
        return storePostsResult.publish()
    }

    func store(userInfoList: [UserInfo]) -> AnyPublisher<Void, Error> {
        register(.store(userInfoList: userInfoList))
        return storeUserInfoListResult.publish()
    }

    func hasLoadedPosts() -> AnyPublisher<Bool, Error> {
        register(.hasLoadedPosts)
        return hasLoadedPostResult.publish()
    }

    func fetch() -> AnyPublisher<LazyList<FullPost>, Error> {
        register(.fetch)
        return fetchPostsResult.publish()
    }

    func fetch(with id: Int64) -> AnyPublisher<FullPost, Error> {
        register(.fetchSinglePost(withId: id))
        return fetchSinglePostResult.publish()
    }
}
