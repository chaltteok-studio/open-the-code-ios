//
//  CachePolicyInterceptor.swift
//  
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Dyson

public struct CachePolicyInterceptor: Interceptor {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Lifecycle
    public func request(
        _ request: URLRequest,
        dyson: Dyson,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    ) {
        guard let cachePolicy = (spec as? Cacheable)?.cachePolicy else {
            continuation(request)
            return
        }
        
        var request = request
        request.cachePolicy = cachePolicy
        
        continuation(request)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
