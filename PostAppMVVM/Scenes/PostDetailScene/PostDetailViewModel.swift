//
//  PostDetailViewModel.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI
import Combine

class PostDetailViewModel: BaseViewModel<PostDetailViewModelState, PostDetailViewModelEvent>,
                           PostDetailViewModelProtocol {
    // MARK: - Stored Properties
    @Published var post: FullPost
    @Published var isRefreshing: Bool = false
    @Published var isShowingAlert: Bool = false
    let interactor: PostDetailInteractor

    // MARK: - Initialization

    init(
        post: FullPost,
        interactor: PostDetailInteractor
    ) {
        self.post = post
        self.interactor = interactor
        super.init(state: .loaded(post))
    }

    // MARK: - Methods

    func reloadPost() {

    }

    func updateWith(post: FullPost) {
        self.post = post
    }

    // MARK: - Override base object methods

    override func reduce(
        _ state: PostDetailViewModelState,
        _ event: PostDetailViewModelEvent
    ) -> PostDetailViewModelState {
        switch state {
        case .loading:
            switch event {
            case .onFailedToLoadPost(let error):
                return .error(error)
            case .onPostLoaded(let post):
                return .loaded(post)
            default:
                return state
            }
        case .loaded, .error(_):
            switch event {
            case .reloadPost(let afterError):
                if afterError {
                    return .loading(previousPost: nil)
                } else {
                    return .loading(previousPost: self.post)
                }
            default:
                return state
            }
        }
    }

    override func whenLoading(
    ) -> Feedback<PostDetailViewModelState, PostDetailViewModelEvent> {
        Feedback { (state: PostDetailViewModelState) -> AnyPublisher<PostDetailViewModelEvent, Never> in
            guard
                case .loading = state
            else {
                return Empty().eraseToAnyPublisher()
            }

            return self
                .interactor
                .reloadPost(postId: self.post.id)
                .map ({ [weak self] post in
                    self?.post = post
                    self?.isRefreshing = false
                    return PostDetailViewModelEvent.onPostLoaded(post)
                })
                .catch { [weak self] failure -> Just<PostDetailViewModelEvent> in
                    self?.isShowingAlert = true
                    return Just(PostDetailViewModelEvent.onFailedToLoadPost(failure))
                }
                .eraseToAnyPublisher()
        }
    }
}
