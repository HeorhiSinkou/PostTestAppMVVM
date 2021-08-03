//
//  PostDetailView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct PostDetailView: View {
    // MARK: Stored Properties
    @ObservedObject var viewModel: PostDetailViewModel
    @State private(set) var isShowingMailView = false

    var body: some View {
        Group {
            self.content
                .listStyle(PlainListStyle())
                .ignoresSafeArea()
                .background(Color.gray.opacity(0.2))
                .pullToRefresh(isShowing: $viewModel.isRefreshing) {
                    self.viewModel.send(event: .reloadPost(afterError: false))
                }
        }// :Group
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
        .navigationBarTitle("Post detail", displayMode: .inline)
    }

    private var content: some View {
        switch viewModel.state {
        case .error(let error):
            return AnyView(AlertView(isPresented: $viewModel.isShowingAlert,
                                     title: "Error",
                                     primaryTitle: "Retry",
                                     message: error.localizedDescription,
                                     primaryAction: {
                                        viewModel.send(event: .reloadPost(afterError: true))
                                     },
                                     secondaryAction: {
                                        viewModel.isShowingAlert = false
                                     })
            )
        case .loaded(let post):
            return AnyView(postView(post: post))

        case .loading(let post):
            return AnyView(
                Group {
                    if let post = post {
                        postView(post: post)
                    } else {
                        ActivityIndicatorView()
                    }
                }
            )
        }
    }
}

private extension PostDetailView {
    func postView(post: FullPost) -> some View {
        return List {
            HStack(alignment: .top, spacing: 10.0) {
                UserContainer(id: post.userId)
                    .buttonStyle(PlainButtonStyle())
                UserData(isShowingMailView: $isShowingMailView,
                         userInfo: post.userInfo)
                    .buttonStyle(PlainButtonStyle())
            }// :HStack
            PostContainer(title: post.title ?? "No title",
                          postBody: post.body ?? "No post body")
        }// :List
    }
}
