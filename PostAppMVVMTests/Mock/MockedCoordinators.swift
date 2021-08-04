//
//  MockedCoordinators.swift
//  PostAppMVVMTests
//
//  Created by Heorhi Sinkou on 4.08.21.
//

@testable import PostAppMVVM

final class MockedPostCoordinator: PostCoordinatorType {
    func open(_ post: FullPost) {
        debugPrint("need open post ")
    }
}
