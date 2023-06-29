//
//  CSSpec.swift
//  
//
//  Created by jsilver on 2022/02/02.
//

import Dyson
import Environment

public protocol CSSpec: Spec, Authorizable, Limitable { }

public extension CSSpec {
    var baseURL: String { Env.URL.baseURL }
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var needsAuth: Bool { true }
}
