//
//  DBPostRepositoryTests.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import Combine
@testable import PostAppMVVM

class DBPostRepositoryTests: XCTestCase {

    var mockedStore: MockedPersistentStore!
    var sut: RealDBPostsRepository!
    var cancelBag = CancelBag()

    override func setUp() {
        mockedStore = MockedPersistentStore()
        sut = RealDBPostsRepository(persistentStore: mockedStore)
        mockedStore.verify()
    }

    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        mockedStore = nil
    }
}

// MARK: - Countries list

final class PostsListDBRepoTests: DBPostRepositoryTests {

    func test_hasLoadedCountries() {
        mockedStore.actions = .init(expected: [
            .count,
            .count
        ])
        let exp = XCTestExpectation(description: #function)
        mockedStore.countResult = 0
        sut.hasLoadedPosts()
            .flatMap { value -> AnyPublisher<Bool, Error> in
                XCTAssertFalse(value)
                self.mockedStore.countResult = 10
                return self.sut.hasLoadedPosts()
            }
            .sinkToResult { result in
                result.assertSuccess(value: true)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }

    func test_storePosts() {
        let posts = FullPost.mockedData
        mockedStore.actions = .init(expected: [
            .update(.init(inserted: posts.count, updated: 0, deleted: 0))
        ])
        let exp = XCTestExpectation(description: #function)
        sut.store(posts: posts)
            .sinkToResult { result in
                result.assertSuccess()
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }

    func test_fetchAllPosts() throws {
        let posts = FullPost.mockedData
        let lazyPosts = LazyList(array: posts, useCache: false)
        mockedStore.actions = .init(expected: [
            .fetchPost(.init(inserted: 0, updated: 0, deleted: 0))
        ])
        try mockedStore.preloadData { context in
            posts.forEach { $0.store(in: context) }
        }
        let exp = XCTestExpectation(description: #function)
        sut
            .fetch()
            .sinkToResult { result in
                result.assertSuccess(value: lazyPosts)
                self.mockedStore.verify()
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 0.5)
    }
}
