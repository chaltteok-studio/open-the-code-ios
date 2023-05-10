//
//  CachePolicyInterceptor.swift
//  
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Network

public struct CachePolicyInterceptor: Interceptor {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Lifecycle
    public func request(
        _ request: URLRequest,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: any TargetSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        guard let cachePolicy = (target as? Cacheable)?.cachePolicy else {
            completion(.success(request))
            return
        }
        
        var request = request
        request.cachePolicy = cachePolicy
        
        completion(.success(request))
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
