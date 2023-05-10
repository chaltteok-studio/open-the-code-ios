//
//  LaunchBuilder.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import RVB
import Reducer
import AppService

public protocol LaunchDependency: Dependency {
    var appService: any AppServiceable { get }
}

public struct LaunchParameter: Dependency {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol LaunchBuildable: Buildable {
    func build(with parameter: LaunchParameter) -> LaunchControllable
}

public final class LaunchBuilder: Builder<LaunchDependency>, LaunchBuildable {
    public func build(with parameter: LaunchParameter) -> LaunchControllable {
        let router = LaunchRouter()
        let reducer = Reducer(LaunchViewReduce(
            appService: dependency.appService
        ))
        let viewController = LaunchViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
