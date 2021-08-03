//
//  PostListCell.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 3.08.21.
//

import SwiftUI

struct PostListCell: View {
    var post: FullPost

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    UserInfoText(text: "User: " + (post.userInfo?.username ?? "unknown"))
                    UserInfoText(text: "Company: " + (post.userInfo?.company?.name ?? "unknown"))
                }// :HStack
                .padding()

                VStack(alignment: .leading, spacing: 12) {
                    Text(post.title ?? "")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .padding(.horizontal, 15)
                        .background(Color.gray.opacity(0.4)).clipShape(Capsule())
                    Text(post.body ?? "")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.horizontal, 15)
                        .background(Color.gray.opacity(0.4)).clipShape(Capsule())
                }// :VStack
                .padding(.bottom, 10)
            }// :VStack
            .padding(.horizontal, 12)
            Spacer()
        }// :HStack
        .frame(maxWidth: .infinity)
        .background(Color.yellow)
        .cornerRadius(12)
    }
}

struct PostListCell_Previews: PreviewProvider {
    static var previews: some View {
        PostListCell(post: FullPost.mockedData[0])
    }
}

struct UserInfoText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.body)
            .lineLimit(3)
            .truncationMode(.tail)
    }
}

