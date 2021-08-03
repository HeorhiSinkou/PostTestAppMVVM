//
//  ImageLoader.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import SwiftUI
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?
    private(set) var isLoading = false
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")

    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    func load() {
        guard
            let url = self.url,
            !isLoading
        else {
            return
        }

        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            // 3.
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0, url: url) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    private func onStart() {
        isLoading = true
    }

    private func onFinish() {
        isLoading = false
    }

    func cancel() {
        cancellable?.cancel()
    }

    private func cache(_ image: UIImage?, url: URL) {
        image.map { cache?[url] = $0 }
    }
}

