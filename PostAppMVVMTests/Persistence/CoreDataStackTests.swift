//
//  CoreDataStackTests.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 3.08.21.
//

import XCTest
import Combine
@testable import PostAppMVVM

class CoreDataStackTests: XCTestCase {

    var sut: CoreDataStack!
    let testDirectory: FileManager.SearchPathDirectory = .cachesDirectory
    var dbVersion: UInt { fatalError("Override") }
    var cancelBag = CancelBag()

    override func setUp() {
        eraseDBFiles()
        sut = CoreDataStack(directory: testDirectory, version: dbVersion)
    }

    override func tearDown() {
        cancelBag = CancelBag()
        sut = nil
        eraseDBFiles()
    }

    func eraseDBFiles() {
        let version = CoreDataStack.Version(dbVersion)
        if let url = version.dbFileURL(testDirectory, .userDomainMask) {
            try? FileManager().removeItem(at: url)
        }
    }
}

// MARK: - Version 1

final class CoreDataStackV1Tests: CoreDataStackTests {

    override var dbVersion: UInt { 1 }

    func test_initialization() {
        let exp = XCTestExpectation(description: #function)
        let request = FullPostMO.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        sut.fetch(request) { _ -> Int? in
            return nil
        }
        .sinkToResult { result in
            result.assertSuccess(value: LazyList<Int>.empty)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func test_inaccessibleDirectory() {
        let sut = CoreDataStack(directory: .adminApplicationDirectory,
                                domainMask: .systemDomainMask, version: dbVersion)
        let exp = XCTestExpectation(description: #function)
        let request = FullPostMO.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        sut.fetch(request) { _ -> Int? in
            return nil
        }
        .sinkToResult { result in
            result.assertFailure()
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func test_counting_onEmptyStore() {
        let request = FullPostMO.newFetchRequest()
        request.predicate = NSPredicate(value: true)
        let exp = XCTestExpectation(description: #function)
        sut.count(request)
        .sinkToResult { result in
            result.assertSuccess(value: 0)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func test_storing_and_countring() {
        let posts = FullPost.mockedData

        let request = FullPostMO.newFetchRequest()
        request.predicate = NSPredicate(value: true)

        let exp = XCTestExpectation(description: #function)
        sut.update { context in
            posts.forEach {
                $0.store(in: context)
            }
        }
        .flatMap { _ in
            self.sut.count(request)
        }
        .sinkToResult { result in
            result.assertSuccess(value: posts.count)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func test_storing_exception() {
        let exp = XCTestExpectation(description: #function)
        sut.update { context in
            throw NSError.test
        }
        .sinkToResult { result in
            result.assertFailure(NSError.test.localizedDescription)
            exp.fulfill()
        }
        .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func test_fetching() {
        let posts = FullPost.mockedData
        let exp = XCTestExpectation(description: #function)
        sut
            .update { context in
                posts.forEach {
                    $0.store(in: context)
                }
            }
            .flatMap { _ -> AnyPublisher<LazyList<FullPost>, Error> in
                let request = FullPostMO.newFetchRequest()
                request.predicate = NSPredicate(format: "id == %@", String(posts[0].id))
                return self.sut.fetch(request) {
                    FullPost(managedObject: $0)
                }
            }
            .sinkToResult { result in
                switch result {
                case .success(let resultPosts):
                    XCTAssertEqual(resultPosts.count, 1)
                    XCTAssertEqual(resultPosts[0].id, posts[0].id)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            }
            .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }
}

