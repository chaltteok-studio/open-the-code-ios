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
    private let staticResponser: any NetworkResponser
    
    @Store
    private var limitAPICall: Bool
    
    // MARK: - Initializer
    public init(
        staticResponser: any NetworkResponser,
        storage: any Storage
    ) {
        self.staticResponser = staticResponser
        
        // Set stored date.
        self._limitAPICall = Store(storage, for: .limitAPICall, default: true)
    }
    
    // MARK: - Public
    public func config() async throws -> Config {
        let result = try await staticResponser.request(GetConfigTarget(.init()))
        
        limitAPICall = result.limitAPICall
        
        return .init(
            minimumVersion: result.minimumVersion
        )
    }
    
    public func notices() async throws -> [Notice] {
        let result = try await staticResponser.request(NoticesTarget(.init()))
        return result.notices.map { Notice($0) }
    }
    
    // MARK: - Private
}
