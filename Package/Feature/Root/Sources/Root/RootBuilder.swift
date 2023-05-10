//
//  RootBuilder.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import RVB
import AppService
import CodeService
import Launch
import Main

public protocol RootDependency: Dependency, LaunchDependency, MainDependency {
    var appService: any AppServiceable { get }
    var codeService: any CodeServiceable { get }
}

public struct RootParameter: Parameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol RootBuildable: Buildable {
    func build(with parameter: RootParameter) -> RootControllable
}

public final class RootBuilder: Builder<RootDependency>, RootBuildable {
    public func build(with parameter: RootParameter) -> RootControllable {
        let launchBuilder = LaunchBuilder(dependency)
        let mainBuilder = MainBuilder(dependency)
        
        let viewController = RootViewController()
        let router = RootRouter(
            launchBuilder: launchBuilder,
            mainBuilder: mainBuilder
        )
        
        viewController.router = router
        
        return viewController
    }
}
