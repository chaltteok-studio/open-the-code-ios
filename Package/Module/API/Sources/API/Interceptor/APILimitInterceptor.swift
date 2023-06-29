//
//  APILimitInterceptor.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Dyson

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
        dyson: Dyson,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    ) {
        guard (spec as? Limitable) != nil && limitAPICall() else {
            continuation(request)
            return
        }
        
        continuation(throwing: CSError(code: .CS99999))
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
