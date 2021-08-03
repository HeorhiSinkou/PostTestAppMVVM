//
//  UserContainerView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import SwiftUI

struct UserContainer: View {
    let id: Int64
    enum Constants {
        static let baseURL = "https://source.unsplash.com/collection/542909/?sig="
        static let side: CGFloat = 100
    }

    var body: some View {
        VStack {
            AsyncImage(
                url: makeImageURL(),
                placeholder: { Text("Loading...")
                    .scaledToFit()
                    .lineLimit(1)
                })// :AsyncImage
                .frame(width: Constants.side, height: Constants.side)
                .scaledToFit()
                .background(Color.yellow)
                .cornerRadius(Constants.side / 2.0)
                .padding(.bottom, 10)
            Spacer()
        }// :VStack
    }

    private func makeImageURL() -> URL? {
        guard
            let url = URL(string: Constants.baseURL + String(id))
        else {
            return nil
        }
        return url
    }
}
