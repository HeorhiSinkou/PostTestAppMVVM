//
//  PostDetailInteractor.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import Foundation
import SwiftUI

protocol PostDetailInteractor {
    func reloadPost(postId: Int64) -> AnyPublisher<FullPost, Error>
}

struct RealPostDetailInteractor: PostDetailInteractor {
    var webRepository: WebPostsRepository
    var dbRepository: DBPostsRepository
    let appState: Store<AppState>

    init(
        webRepository: WebPostsRepository,
        dbRepository: DBPostsRepository,
        appState: Store<AppState>
    ) {
        self.webRepository = webRepository
        self.dbRepository = dbRepository
        self.appState = appState
    }

    func reloadPost(
        postId: Int64
    ) -> AnyPublisher<FullPost, Error> {

        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [webRepository] _ -> AnyPublisher<FullPost, Error> in
                webRepository.loadPost(with: postId)
                    .ensureTimeSpan(requestHoldBackTimeInterval)
            }
            .flatMap { fullPost in
                storePostAndUpdateUserInfo(posts: [fullPost])
            }
            .flatMap { [dbRepository] _ in
                dbRepository.fetch(with: postId)
            }.eraseToAnyPublisher()
    }

    private func storePostAndUpdateUserInfo(posts: [FullPost]) -> AnyPublisher<Void, Error> {
        dbRepository.store(posts: posts)
            .flatMap { [posts] in
                webRepository
                    .loadUsers(userIds: Set(posts.map({ $0.userId })))
                    .ensureTimeSpan(requestHoldBackTimeInterval)
                    .flatMap { [dbRepository] in
                        dbRepository.store(userInfoList: $0)
                    }
            }
            .eraseToAnyPublisher()
    }

    private var requestHoldBackTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 15
    }
}

struct StubPostDetailInteractor: PostDetailInteractor {
    func reloadPost(postId: Int64) -> AnyPublisher<FullPost, Error> {
        Just<FullPost>.withErrorType(FullPost.mockedData[0], Error.self)
    }
}

