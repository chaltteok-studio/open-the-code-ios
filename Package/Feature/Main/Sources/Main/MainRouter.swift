//
//  MainRouter.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import RVB
import EnterCode
import CreateCode
import Setting

protocol MainRoutable: Routable {
    associatedtype EnterCode: EnterCodeControllable
    func routeToEnterCode(with parameter: EnterCodeParameter) -> EnterCode
    
    associatedtype CreateCode: CreateCodeControllable
    func routeToCreateCode(with parameter: CreateCodeParameter) -> CreateCode
    
    func routeToSetting(with parameter: SettingParameter) -> any SettingControllable
}

final class MainRouter: MainRoutable {
    // MARK: - Property
    private let enterCodeBuilder: any EnterCodeBuildable
    private let createCodeBuilder: any CreateCodeBuildable
    private let settingBuilder: any SettingBuildable
    
    // MARK: - Initializer
    init(
        enterCodeBuilder: any EnterCodeBuildable,
        createCodeBuilder: any CreateCodeBuildable,
        settingBuilder: any SettingBuildable
    ) {
        self.enterCodeBuilder = enterCodeBuilder
        self.createCodeBuilder = createCodeBuilder
        self.settingBuilder = settingBuilder
    }
    
    // MARK: - Public
    func routeToEnterCode(with parameter: EnterCodeParameter) -> some EnterCodeControllable {
        EnterCodeViewAdapter(enterCodeBuilder, with: parameter)
    }
    
    func routeToCreateCode(with parameter: CreateCodeParameter) -> some CreateCodeControllable {
        CreateCodeViewAdapter(createCodeBuilder, with: parameter)
    }
    
    func routeToSetting(with parameter: SettingParameter) -> any SettingControllable {
        settingBuilder.build(with: parameter)
    }

    // MARK: - Private
}
