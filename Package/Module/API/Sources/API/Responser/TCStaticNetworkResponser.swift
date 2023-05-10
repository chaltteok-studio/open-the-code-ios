//
//  TCStaticNetworkResponser.swift
//
//
//  Created by jsilver on 2022/03/21.
//

import Foundation
import Network

public final class TCStaticNetworkResponser: NetworkResponser {
    // MARK: - Property
    public let provider: any NetworkProvider
    
    // MARK: - Initializer
    public init(provider: any NetworkProvider) {
        self.provider = provider
    }
    
    // MARK: - Lifecycle
    public func response<T: Target>(
        target: T,
        result: Response,
        handler: (Result<T.Result, Error>) -> Void
    ) {
        switch result {
        case let .success((data, response)):
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(TCNetworkError.emptyResponse))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                handler(.failure(TCNetworkError.invalidStatusCode(response.statusCode)))
                return
            }
            
            do {
                let result = try target.result.map(data)
                handler(.success(result))
            } catch {
                handler(.failure(error))
            }
            
        case let .failure(error):
            handler(.failure(error))
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
