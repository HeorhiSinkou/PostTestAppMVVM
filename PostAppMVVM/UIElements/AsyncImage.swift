//
//  AsyncImage.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder

    init(
        url: URL?,
        cache: ImageCache,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
