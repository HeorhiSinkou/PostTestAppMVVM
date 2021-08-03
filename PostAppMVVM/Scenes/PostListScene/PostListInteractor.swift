//
//  PostListInteractor.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import Foundation
import SwiftUI

protocol PostListInteractor {
    func fetchPosts(with refresh: Bool) -> AnyPublisher<LazyList<FullPost>, Error>
}

struct RealPostListInteractor: PostListInteractor {
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

    func fetchPosts(with refresh: Bool) -> AnyPublisher<LazyList<FullPost>, Error> {
        if refresh {
            return refreshPostsInDB()
        } else {
            return loadPosts()
        }
    }

    func loadPosts() -> AnyPublisher<LazyList<FullPost>, Error> {
        Just<Void>
            .withErrorType(Error.self)
            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
                dbRepository.hasLoadedPosts()
            }
            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
                if hasLoaded {
                    return Just<Void>.withErrorType(Error.self)
                } else {
                    return self.refreshPostsList()
                }
            }
            .flatMap { [dbRepository] _ in
                dbRepository.fetch()
            }
            .eraseToAnyPublisher()
    }

    func refreshPostsInDB() -> AnyPublisher<LazyList<FullPost>, Error> {
        Just<Void>
            .withErrorType(Error.self)
            .flatMap {
                self.refreshPostsList()
            }
            .flatMap { [dbRepository] _ in
                dbRepository.fetch()
            }
            .eraseToAnyPublisher()
    }

    func refreshPostsList() -> AnyPublisher<Void, Error> {
        return webRepository
            .loadPosts()
            .ensureTimeSpan(requestHoldBackTimeInterval)
            .flatMap {
                storePosts(posts: $0)
            }
            .eraseToAnyPublisher()
    }

    private func storePosts(posts: [FullPost]) -> AnyPublisher<Void, Error> {
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
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
    }
}

struct StubPostListInteractor: PostListInteractor {
    func fetchPosts(with refresh: Bool) -> AnyPublisher<LazyList<FullPost>, Error> {
        let posts = LazyList(array: FullPost.mockedData, useCache: false)
        return Just<LazyList<FullPost>>.withErrorType(posts, Error.self)
    }
}

