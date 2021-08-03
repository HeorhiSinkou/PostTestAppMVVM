//
//  RootCoordinatorView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI

struct RootCoordinatorView: View {
    // MARK: - Stored Properties

    @ObservedObject var coordinator: RootCoordinator

    var body: some View {
        PostCoordinatorView(coordinator: coordinator.postCoordinator)
    }
}

//struct RootCoordinatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootCoordinatorView()
//    }
//}
