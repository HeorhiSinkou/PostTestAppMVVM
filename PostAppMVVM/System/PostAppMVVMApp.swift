//
//  PostAppMVVMApp.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

@main
struct PostAppMVVMApp: App {
    // MARK: - Stored Properties

    @StateObject var coordinator = RootCoordinator()
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(coordinator: coordinator)
                .inject(coordinator.container)
        }
    }
}
