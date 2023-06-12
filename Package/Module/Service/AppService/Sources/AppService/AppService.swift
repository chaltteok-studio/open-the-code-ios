//
//  AppService.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import Service

public protocol AppServiceable {
    /// Get application configuration informations.
    func config() async throws -> Config
    /// Get application notices.
    func notices() async throws -> [Notice]
}

public final class AppService: AppServiceable {
    // MARK: - Property
    private let provider: any NetworkProvider
    
    @Store
    private var limitAPICall: Bool
    
    // MARK: - Initializer
    public init(
        provider: any NetworkProvider,
        storage: any Storage
    ) {
        self.provider = provider
        
        // Set stored date.
        self._limitAPICall = Store(storage, for: .limitAPICall, default: true)
    }
    
    // MARK: - Public
    public func config() async throws -> Config {
        let result = try await provider.responser(TCStaticNetworkResponser.self)
            .request(GetConfigTarget(.init()))
        
        limitAPICall = result.limitAPICall
        
        return .init(
            minimumVersion: result.minimumVersion
        )
    }
    
    public func notices() async throws -> [Notice] {
        let result = try await provider.responser(TCStaticNetworkResponser.self)
            .request(NoticesTarget(.init()))
        return result.notices.map { Notice($0) }
    }
    
    // MARK: - Private
}
