//
//  PostListViewModelTests.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import SwiftUI
import Combine
@testable import PostAppMVVM

final class PostListViewModelTests: XCTestCase {

    let appState = CurrentValueSubject<AppState, Never>(AppState())
    var mockedInteractor: MockedPostListInteractor!
    var subscriptions = Set<AnyCancellable>()
    var sut: PostListViewModel!

    override func setUp() {
        appState.value = AppState()
        mockedInteractor = MockedPostListInteractor(expected: [])
        sut = PostListViewModel(title: "Test posts title", interactor: mockedInteractor,
                                coordinator: MockedPostCoordinator())
    }

    override func tearDown() {
        subscriptions = Set<AnyCancellable>()
    }

    func test_viewModelEvent_onAppear_whenIdle() {
        let exp = XCTestExpectation(description: #function)

        switch sut.reduce(.idle, .onAppear) {
        case .error(let error):
            XCTFail(error.localizedDescription)
        case .idle:
            XCTFail()
        case .loaded(_):
            XCTFail()
        case .loading(let posts):
            XCTAssertNil(posts)
        }
        exp.fulfill()
        wait(for: [exp], timeout: 2)
        sut.send(event: .onAppear)
    }

    func test_viewModelEvent_refresh_whenLoaded() {
        let list = FullPost.mockedData.lazyList
        let exp = XCTestExpectation(description: #function)

        switch sut.reduce(.loaded(list.lazyList), .refresh(afterError: false)) {
        case .error(let error):
            XCTFail(error.localizedDescription)
        case .idle:
            XCTFail()
        case .loaded(_):
            XCTFail()
        case .loading(let posts):
            XCTAssertNil(posts)
        }
        exp.fulfill()
        wait(for: [exp], timeout: 2)
        sut.send(event: .onAppear)
    }
}
