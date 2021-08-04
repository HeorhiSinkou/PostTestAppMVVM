//
//  RootCoordinatorView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct RootCoordinatorView: View {
    // MARK: - Stored Properties

    @ObservedObject var coordinator: RootCoordinator
    private let isRunningTests: Bool

    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
        self.isRunningTests = ProcessInfo.processInfo.isRunningTests
    }

    var body: some View {
        Group {
            if isRunningTests {
                Text("Unit test running")
            } else {
                PostCoordinatorView(coordinator: coordinator.postCoordinator)
            }
        }
    }
}
