//
//  PostDetailViewModelProtocol.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

import Combine
import SwiftUI

protocol PostDetailViewModelProtocol {
}

enum PostDetailViewModelState {
    case loading(previousPost: FullPost?)
    case loaded(FullPost)
    case error(Error)
}

enum PostDetailViewModelEvent {
    case onAppear
    case onPostLoaded(FullPost)
    case onFailedToLoadPost(Error)
    case reloadPost(afterError: Bool)
}
