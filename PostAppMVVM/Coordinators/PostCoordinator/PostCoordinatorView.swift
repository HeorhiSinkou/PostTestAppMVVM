//
//  PostCoordinatorView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct PostCoordinatorView: View {
    // MARK: - Stored Properties
    @ObservedObject var coordinator: PostCoordinator

    init(coordinator: PostCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationView {
            //PostListView(viewModel: coordinator.postListViewModel)
            self.postListView()
                .navigation(item: $coordinator.postDetailViewModel) { viewModel in
                    postDetailView(viewModel)
                }
        }
    }

    @ViewBuilder
    private func postDetailView(_ viewModel: PostDetailViewModel) -> some View {
        PostDetailView(viewModel: viewModel)
    }

    private func postListView() -> some View {
        return PostListView(viewModel: coordinator.postListViewModel)
    }

}
