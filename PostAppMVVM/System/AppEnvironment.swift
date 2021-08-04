//
//  AppEnvironment.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
}

enum BaseURL: String {
    case jsonPlaceholder = "https://jsonplaceholder.typicode.com"
    case test = "https://test.com"
}

extension AppEnvironment {

    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(appState: appState)
        let interactors = configuredInteractors(appState: appState,
                                                dbRepositories: dbRepositories,
                                                webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(container: diContainer)
    }

    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 2
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }

    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let postsRepository = RealWebPostsRepository(session: session,
                                                     baseURL: .jsonPlaceholder)
        let userRepository = RealWebUserRepository(session: session,
                                                   baseURL: .jsonPlaceholder)
        return .init(webPostsRepository: postsRepository,
                     webUserRepository: userRepository)
    }

    private static func configuredDBRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let dbPostsRepository = RealDBPostsRepository(persistentStore: persistentStore)
        return .init(dbPostsRepository: dbPostsRepository)
    }

    private static func configuredInteractors(
        appState: Store<AppState>,
        dbRepositories: DIContainer.DBRepositories,
        webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Interactors {
        let postListInteractor = RealPostListInteractor(webRepository: webRepositories.webPostsRepository,
                                                  dbRepository: dbRepositories.dbPostsRepository,
                                                  appState: appState)
        let postDetailInteractor = RealPostDetailInteractor(webRepository: webRepositories.webPostsRepository,
                                                            dbRepository: dbRepositories.dbPostsRepository,
                                                            appState: appState)
        return .init(postListInteractor: postListInteractor,
                     postDetailInteractor: postDetailInteractor)
    }
}

extension DIContainer {
    struct WebRepositories {
        let webPostsRepository: WebPostsRepository
        let webUserRepository: WebUserRepository
    }

    struct DBRepositories {
        let dbPostsRepository: DBPostsRepository
    }
}


