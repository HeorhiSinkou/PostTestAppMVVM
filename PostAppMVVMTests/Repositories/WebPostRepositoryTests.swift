//
//  WebPostRepositoryTests.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
import Combine
@testable import PostAppMVVM

final class WebPostRepositoryTests: XCTestCase {

    private var sut: RealWebPostsRepository!
    private var subscriptions = Set<AnyCancellable>()

    typealias API = PostApiController
    typealias Mock = MockingRequest.MockedResponse

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
        sut = RealWebPostsRepository(session: .mockedResponsesOnly,
                                     baseURL: .test)
    }

    override func tearDown() {
        MockingRequest.removeAllMocks()
    }

    // MARK: - Tests

    func test_allPosts() throws {
        let data = FullPost.mockedData
        try mock(.posts, result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadPosts().sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }

    func test_loadUser() throws {
        let data = UserInfo.mockUser
        try mock(.user(id: 1), result: .success(data))
        let exp = XCTestExpectation(description: "Completion")
        sut.loadUser(id: data.id).sinkToResult { result in
            result.assertSuccess(value: data)
            exp.fulfill()
        }.store(in: &subscriptions)
        wait(for: [exp], timeout: 2)
    }

    // MARK: - Helper

    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        MockingRequest.add(mock: mock)
    }
}

