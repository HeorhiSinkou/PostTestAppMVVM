//
//  InteractorContainer.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

extension DIContainer {
    struct Interactors {
        let postListInteractor: PostListInteractor
        let postDetailInteractor: PostDetailInteractor

        init(
            postListInteractor: PostListInteractor,
            postDetailInteractor: PostDetailInteractor
        ) {
            self.postListInteractor = postListInteractor
            self.postDetailInteractor = postDetailInteractor
        }

        static var stub: Self {
            .init(postListInteractor: StubPostListInteractor(),
                  postDetailInteractor: StubPostDetailInteractor())
        }
    }
}

