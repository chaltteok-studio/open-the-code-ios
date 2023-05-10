//
//  MainBuilder.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import RVB
import AppService
import CodeService
import EnterCode
import CreateCode
import Setting

public protocol MainDependency: Dependency, EnterCodeDependency, CreateCodeDependency, SettingDependency {
    var appService: any AppServiceable { get }
    var codeService: any CodeServiceable { get }
}

public struct MainParameter: Parameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol MainBuildable: Buildable {
    func build(with parameter: MainParameter) -> MainControllable
}

public final class MainBuilder: Builder<MainDependency>, MainBuildable {
    public func build(with parameter: MainParameter) -> MainControllable {
        let enterCodeBuilder = EnterCodeBuilder(dependency)
        let createCodeBuilder = CreateCodeBuilder(dependency)
        let settingBuilder = SettingBuilder(dependency)
        
        let router = MainRouter(
            enterCodeBuilder: enterCodeBuilder,
            createCodeBuilder: createCodeBuilder,
            settingBuilder: settingBuilder
        )
        let viewController = MainViewController(
            router: router
        )
        
        return viewController
    }
}
