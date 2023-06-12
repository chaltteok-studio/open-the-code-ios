//
//  AppBuilder.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import Foundation
import Logger
import RVB
import Network
import Environment
import API
import Storage
import Store
import AppService
import UserService
import CodeService
import Root

public struct AppDependency: Dependency, RootDependency {
    // MARK: - Property
    public let appService: any AppServiceable
    public let userService: any UserServiceable
    public let codeService: any CodeServiceable
    
    // MARK: - Initializer
    public init() {
        let userDefaultStorage = UserDefaultStorage()
        
        let networkProvider = URLNetworkProvider(
            interceptors: [
                LogInterceptor(),
                APILimitInterceptor {
                    (try? userDefaultStorage.read(forKey: StoreKey.limitAPICall.rawValue)) ?? false
                },
                HeaderInterceptor(
                    key: "Accept-Language",
                    value: Env.locale.rawValue
                ),
                CachePolicyInterceptor()
            ]
        )
        
        let appService = AppService(
            provider: networkProvider,
            storage: userDefaultStorage
        )
        
        let userService = UserService(
            storage: userDefaultStorage
        )
        
        let codeService = CodeService(
            storage: userDefaultStorage,
            provider: networkProvider,
            userService: userService
        )
        
        self.appService = appService
        self.userService = userService
        self.codeService = codeService
    }
}

public struct AppParameter: Parameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol AppBuildable: Buildable {
    func build(with parameter: AppParameter) -> AppControllable
}

public final class AppBuilder: Builder<AppDependency>, AppBuildable {
    public func build(with parameter: AppParameter) -> AppControllable {
        let rootBuilder = RootBuilder(dependency)
        
        let router = AppRouter(
            rootBuilder: rootBuilder
        )
        let app = App(
            router: router,
            codeService: dependency.codeService
        )
        
        return app
    }
}
