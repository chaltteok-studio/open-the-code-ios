//
//  AppRouter.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import RVB
import Root

protocol AppRoutable: Routable {
    /// Build `Root` module for routing.
    func routeToRoot(with parameter: RootParameter) -> any RootControllable
}

final class AppRouter: AppRoutable {
    // MARK: - Property
    private let rootBuilder: any RootBuildable
    
    // MARK: - Initializer
    init(rootBuilder: any RootBuildable) {
        self.rootBuilder = rootBuilder
    }
    
    // MARK: - Public
    func routeToRoot(with parameter: RootParameter) -> any RootControllable {
        rootBuilder.build(with: parameter)
    }
    
    // MARK: - Private
}
