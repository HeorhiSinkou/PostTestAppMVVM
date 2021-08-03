//
//  PostListViewModel.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI
import Combine

final class PostListViewModel: BaseViewModel<PostListViewModelState, PostListViewModelEvent>,
                               PostListViewModelProtocol {
    // MARK: - Stored Properties

    let title: String
    @Published var isRefreshing: Bool = false
    @Published var isShowingAlert: Bool = false
    private unowned let coordinator: PostCoordinator
    let interactor: PostListInteractor
    private var loadedPosts: LazyList<FullPost>?
    private var needRefresh: Bool = false

    // MARK: - Initialization

    init(title: String,
         interactor: PostListInteractor,
         coordinator: PostCoordinator
    ) {
        self.title = title
        self.interactor = interactor
        self.coordinator = coordinator

        super.init(state: .idle)
    }

    // MARK: Coordinator methods

    func open(_ post: FullPost) {
        self.coordinator.open(post)
    }

    // MARK: - Override base object methods

    override func reduce(
        _ state: PostListViewModelState,
        _ event: PostListViewModelEvent
    ) -> PostListViewModelState {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading(self.loadedPosts)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadPosts(let error):
                return .error(error)
            case .onPostsLoaded(let posts):
                return .loaded(posts)
            default:
                return state
            }
        case .loaded, .error(_):
            switch event {
            case .refresh(let afterError):
                self.needRefresh = true
                if afterError {
                    return .loading(nil)
                } else {
                    return .loading(self.loadedPosts)
                }
            default:
                return state
            }
        }
    }

    override func whenLoading() -> Feedback<PostListViewModelState,
                                            PostListViewModelEvent> {
        Feedback { (state: PostListViewModelState) -> AnyPublisher<PostListViewModelEvent, Never> in
            guard
                case .loading = state
            else {
                return Empty().eraseToAnyPublisher()
            }

            let refresh = self.needRefresh
            self.needRefresh = false
            return
                self.interactor
                .fetchPosts(with: refresh)
                .map ({ posts in
                        self.loadedPosts = posts
                        self.isRefreshing = false
                        return PostListViewModelEvent.onPostsLoaded(posts) })
                .catch { failure -> Just<PostListViewModelEvent> in
                    self.isShowingAlert = true
                    return Just(PostListViewModelEvent.onFailedToLoadPosts(failure))
                }
                .eraseToAnyPublisher()
        }
    }
}
