//
//  PostListInteractorTest.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import SwiftUI
import Combine
@testable import PostAppMVVM

class PostListInteractorTests: XCTestCase {

    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var mockedWebRepo: MockedWebPostRepository!
    var mockedDBRepo: MockedDBPostRepository!
    var subscriptions = Set<AnyCancellable>()
    var sut: RealPostListInteractor!

    override func setUp() {
        appState.value = AppState()
        mockedWebRepo = MockedWebPostRepository()
        mockedDBRepo = MockedDBPostRepository()
        sut = RealPostListInteractor(webRepository: mockedWebRepo,
                                     dbRepository: mockedDBRepo,
                                     appState: appState)
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }
}

final class LoadPostListTests: PostListInteractorTests {

    func test_filledDB_successfullFetch() {
        let list = FullPost.mockedData
        let exp = XCTestExpectation(description: #function)
        // Configuring expected actions on repositories
        mockedWebRepo.actions = .init(expected: [
        ])
        mockedDBRepo.actions = .init(expected: [
            .hasLoadedPosts,
            .fetch
        ])
        // Configuring responses from repositories
        mockedDBRepo.hasLoadedPostResult = .success(true)
        mockedDBRepo.fetchPostsResult = .success(list.lazyList)

        //Assert
        sut.loadPosts()
            .sinkToResult({ result in
                switch result {
                case .success(let posts):
                    XCTAssertEqual(posts.count, list.count)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                self.mockedWebRepo.verify()
                self.mockedDBRepo.verify()
                exp.fulfill()
            })
            .store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }
}
