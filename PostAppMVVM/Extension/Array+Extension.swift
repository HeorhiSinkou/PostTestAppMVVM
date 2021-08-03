//
//  Array+Extension.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 3.08.21.
//

import Foundation

enum GetError: Error {
    case indexOutOfRange
}

extension Array {
    func safeGetElement(index: Int) throws -> Element {
        guard
            self.indices.contains(index)
        else {
            throw GetError.indexOutOfRange
        }
        return self[index]
    }
}
