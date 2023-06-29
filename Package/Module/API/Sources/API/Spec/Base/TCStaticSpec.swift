//
//  TCStaticSpec.swift
//
//
//  Created by jsilver on 2022/02/02.
//

import Foundation
import Dyson
import Environment

public protocol TCStaticSpec: Spec, Cacheable { }

public extension TCStaticSpec {
    var baseURL: String { Env.URL.staticURL }
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalAndRemoteCacheData }
}
