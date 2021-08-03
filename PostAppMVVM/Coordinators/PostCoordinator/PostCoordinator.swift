//
//  PostCoordinator.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

class PostCoordinator: ObservableObject, Identifiable {

    // MARK: Stored Properties

    @Published var postListViewModel: PostListViewModel!
    @Published var postDetailViewModel: PostDetailViewModel?
    let injected: DIContainer

    private unowned let parent: RootCoordinator

    // MARK: Initialization

    init(title: String,
         injected: DIContainer,
         parent: RootCoordinator) {
        self.injected = injected
        self.parent = parent

        self.postListViewModel = .init(
            title: title,
            interactor: injected.interactors.postListInteractor,
            coordinator: self
        )
    }

    // MARK: Methods

    func open(_ post: FullPost) {
        self.postDetailViewModel = PostDetailViewModel(post: post,
                                                       interactor: injected.interactors.postDetailInteractor,
                                                       coordinator: self)
    }

    func open(_ url: URL) {
        self.parent.open(url)
    }
}
