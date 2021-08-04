//
//  Result+Extension.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 4.08.21.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}
