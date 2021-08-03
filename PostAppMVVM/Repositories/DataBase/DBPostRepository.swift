//
//  DBPostRepository.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import CoreData
import Combine

protocol DBPostsRepository {
    func hasLoadedPosts() -> AnyPublisher<Bool, Error>
    func store(posts: [FullPost]) -> AnyPublisher<Void, Error>
    func store(userInfoList: [UserInfo]) -> AnyPublisher<Void, Error>
    func fetch() -> AnyPublisher<LazyList<FullPost>, Error>
    func fetch(with id: Int64) -> AnyPublisher<FullPost, Error>
}

struct RealDBPostsRepository: DBPostsRepository {
    let persistentStore: PersistentStore

    func hasLoadedPosts() -> AnyPublisher<Bool, Error> {
        let fetchRequest = FullPostMO.justOnePost()
        return persistentStore
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }

    func store(posts: [FullPost]) -> AnyPublisher<Void, Error> {
        return persistentStore
            .update { context in
                posts.forEach {
                    $0.store(in: context)
                }
            }
    }

    func store(userInfoList: [UserInfo]) -> AnyPublisher<Void, Error> {
        return persistentStore
            .update { context in
                userInfoList.forEach {
                    $0.store(in: context)
                }
            }
    }

    func fetch() -> AnyPublisher<LazyList<FullPost>, Error> {
        let fetchRequest = FullPostMO.posts()
        return persistentStore
            .fetch(fetchRequest) {
                FullPost(managedObject: $0)
            }
            .eraseToAnyPublisher()
    }

    func fetch(with id: Int64) -> AnyPublisher<FullPost, Error> {
        let fetchRequest = FullPostMO.post(id: id)
        return persistentStore
            .fetchSingle(fetchRequest) {
                FullPost(managedObject: $0)
            }
            .eraseToAnyPublisher()
    }
}

