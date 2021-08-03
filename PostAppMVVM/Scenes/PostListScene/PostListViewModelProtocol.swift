//
//  PostListViewModelProtocol.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import SwiftUI

protocol PostListViewModelProtocol {
    var state: PostListViewModelState { get }
}

enum PostListViewModelState {
    case idle
    case loading(LazyList<FullPost>?)
    case loaded(LazyList<FullPost>)
    case error(Error)
}

enum PostListViewModelEvent {
        case onAppear
        case onSelectPost(FullPost)
        case onPostsLoaded(LazyList<FullPost>)
        case onFailedToLoadPosts(Error)
        case refresh(afterError: Bool)
}
