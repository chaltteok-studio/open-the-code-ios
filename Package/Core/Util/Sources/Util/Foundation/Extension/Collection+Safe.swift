//
//  Collection+Safe.swift
//
//
//  Created by jsilver on 2022/02/12.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
