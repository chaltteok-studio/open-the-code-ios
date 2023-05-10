//
//  Cacheable.swift
//  
//
//  Created by JSilver on 2023/03/21.
//

import Foundation

public protocol Cacheable {
    var cachePolicy: URLRequest.CachePolicy { get }
}
