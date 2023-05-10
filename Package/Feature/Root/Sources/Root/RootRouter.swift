//
//  RootRouter.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import RVB
import Launch
import Main

protocol RootRoutable: Routable {
    /// Build `Launch` module for routing.
    func routeToLaunch(with parameter: LaunchParameter) -> any LaunchControllable
    /// Build `Main` module for routing.
    func routeToMain(with parameter: MainParameter) -> any MainControllable
}

final class RootRouter: RootRoutable {
    // MARK: - Property
    private let launchBuilder: LaunchBuildable
    private let mainBuilder: MainBuildable
    
    // MARK: - Initializer
    init(
        launchBuilder: LaunchBuildable,
        mainBuilder: MainBuildable
    ) {
        self.launchBuilder = launchBuilder
        self.mainBuilder = mainBuilder
    }
    
    // MARK: - Public
    func routeToLaunch(with parameter: LaunchParameter) -> any LaunchControllable {
        launchBuilder.build(with: parameter)
    }
    
    func routeToMain(with parameter: MainParameter) -> any MainControllable {
        mainBuilder.build(with: parameter)
    }
    
    // MARK: - Private
}
