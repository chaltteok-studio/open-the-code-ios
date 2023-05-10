//
//  CSTarget.swift
//  
//
//  Created by jsilver on 2022/02/02.
//

import Network
import Environment

public protocol CSTarget: Target, Authorizable, Limitable { }

public extension CSTarget {
    var baseURL: String { Env.URL.baseURL }
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var needsAuth: Bool { true }
}
