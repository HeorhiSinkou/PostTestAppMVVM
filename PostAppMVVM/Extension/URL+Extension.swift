//
//  URL+Extension.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Foundation

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}
