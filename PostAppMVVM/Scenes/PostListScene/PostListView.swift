//
//  PostListView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct PostListView: View {
    // MARK: - Stored Properties
    @ObservedObject var viewModel: PostListViewModel

    var body: some View {
        Group {
            content
                .navigationBarTitle("Posts", displayMode: .large
                )
                .animation(.easeOut(duration: 0.3))
                .pullToRefresh(isShowing: $viewModel.isRefreshing) {
                    viewModel.send(event: .refresh(afterError: false))
                }
        }
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }

    private var content: some View {
        switch viewModel.state {
        case .idle:
            return AnyView(Color.clear)
        case .loading(let posts):
            return AnyView(
                Group {
                    if let posts = posts, !posts.isEmpty {
                        list(of: posts)
                    } else {
                        ActivityIndicatorView()
                    }
                }
            )
        case .error(let error):
            return AnyView(AlertView(isPresented: $viewModel.isShowingAlert,
                                     title: "Error",
                                     primaryTitle: "Retry",
                                     message: error.localizedDescription,
                                     primaryAction: {
                                        viewModel.send(event: .refresh(afterError: true))
                                     },
                                     secondaryAction: {
                                        viewModel.isShowingAlert = false
                                     })
            )
        case .loaded(let posts):
            return AnyView(list(of: posts))
        }
    }

    private func list(of posts: LazyList<FullPost>) -> some View {
        return List(posts,
             id: \.id) { post in
            ZStack {
                PostListCell(post: post)
                    .onNavigation {
                        viewModel.open(post)
                    }
            }// :ZStack
        }// :List
    }
}
