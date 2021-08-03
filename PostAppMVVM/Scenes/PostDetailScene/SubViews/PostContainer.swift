//
//  PostContainer.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct PostContainer: View {
    var title: String
    var postBody: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(title)
                .fixedSize(horizontal: false, vertical: true)
            Text(postBody)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
