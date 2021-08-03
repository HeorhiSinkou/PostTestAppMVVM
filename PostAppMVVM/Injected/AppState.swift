//
//  AppState.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var system = System()
    //var permissions = Permissions()
}

extension AppState {
    struct UserData: Equatable {
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
