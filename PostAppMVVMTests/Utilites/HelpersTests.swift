//
//  HelpersTests.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import XCTest
@testable import PostAppMVVM

class HelpersTests: XCTestCase {
    func test_result_isSuccess() {
        let sut1 = Result<Void, Error>.success(())
        let sut2 = Result<Void, Error>.failure(NSError.test)
        XCTAssertTrue(sut1.isSuccess)
        XCTAssertFalse(sut2.isSuccess)
    }
}

