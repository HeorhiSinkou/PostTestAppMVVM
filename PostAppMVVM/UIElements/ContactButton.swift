//
//  ContactButton.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct ContactButton: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.gray)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}
