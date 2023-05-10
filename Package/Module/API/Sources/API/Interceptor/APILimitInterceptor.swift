//
//  APILimitInterceptor.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Network

public struct APILimitInterceptor: Interceptor {
    // MARK: - Property
    private let limitAPICall: () -> Bool
    
    // MARK: - Initializer
    public init(limitAPICall: @escaping () -> Bool) {
        self.limitAPICall = limitAPICall
    }
    
    // MARK: - Lifecycle
    public func request(
        _ request: URLRequest,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: any TargetSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        guard (target as? Limitable) != nil && limitAPICall() else {
            completion(.success(request))
            return
        }
        
        completion(.failure(CSError(code: .CS99999)))
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
