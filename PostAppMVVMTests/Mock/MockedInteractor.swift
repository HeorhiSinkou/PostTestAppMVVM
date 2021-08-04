//
//  MockedInteractor.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import SwiftUI
import Combine
@testable import PostAppMVVM

extension DIContainer.Interactors {
    static func mocked(
        postInteractor: [MockedPostListInteractor.Action] = [],
        postDetailInteractor: [MockedPostDetailInteractor.Action] = []
    ) -> DIContainer.Interactors {
        .init(
            postListInteractor: MockedPostListInteractor(expected: postInteractor),
            postDetailInteractor: MockedPostDetailInteractor(expected: postDetailInteractor)
        )
    }

    func verify(file: StaticString = #file, line: UInt = #line) {
        (postListInteractor as? MockedPostListInteractor)?
            .verify(file: file, line: line)
        (postDetailInteractor as? MockedPostDetailInteractor)?
            .verify(file: file, line: line)
    }
}

// MARK: - PostListInteractor

struct MockedPostListInteractor: Mock, PostListInteractor {
    enum Action: Equatable {
        case fetchPost(refresh: Bool)
    }

    let actions: MockActions<Action>
    var fetchPostResult: Result<LazyList<FullPost>, Error> = .success(FullPost.mockedData.lazyList)

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func fetchPosts(with refresh: Bool) -> AnyPublisher<LazyList<FullPost>, Error> {
        register(.fetchPost(refresh: refresh))
        return fetchPostResult.publish()
    }
}

// MARK: - PostDetailInteractor

struct MockedPostDetailInteractor: Mock, PostDetailInteractor {
    enum Action: Equatable {
        case reloadPost(id: Int64)
    }

    var reloadPostResult: Result<FullPost, Error> = .success(FullPost.mockedData[0])
    let actions: MockActions<Action>

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func reloadPost(postId: Int64) -> AnyPublisher<FullPost, Error> {
        register(.reloadPost(id: postId))
        return reloadPostResult.publish()
    }
}
