//
//  TCStaticTarget.swift
//
//
//  Created by jsilver on 2022/02/02.
//

import Foundation
import Network
import Environment

public protocol TCStaticTarget: Target, Cacheable { }

public extension TCStaticTarget {
    var baseURL: String { Env.URL.staticURL }
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }
}
