//
//  RootCoordinator.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation
import SwiftUI

class RootCoordinator: ObservableObject {

    // MARK: Stored Properties

    @Published var postCoordinator: PostCoordinator!
    @Published var openedURL: URL?
    private(set) var container: DIContainer

    // MARK: Initialization

    init() {
        let environment = AppEnvironment.bootstrap()
        self.container = environment.container
        self.postCoordinator = .init(title: "Posts",
                                     injected: container,
                                     parent: self)
    }

    // MARK: Methods

    func open(_ url: URL) {
        self.openedURL = url
    }
}
