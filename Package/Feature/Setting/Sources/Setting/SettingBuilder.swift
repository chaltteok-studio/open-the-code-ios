//
//  SettingBuilder.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import RVB
import Reducer
import CodeService
import TCUIKit
import Notice
import MyCodes
import BlockedCodes
import OpenSourceLicense

public protocol SettingDependency: Dependency, NoticeListDependency, MyCodesDependency, BlockedCodesDependency, OpenSourceLicenseListDependency {
    var codeService: any CodeServiceable { get }
}

public struct SettingParameter {
    // MARK: - Property
    let menus: Menus?
    
    // MARK: - Initializer
    public init(menus: Menus? = nil) {
        self.menus = menus
    }
}

public protocol SettingBuildable: Buildable {
    func build(with parameter: SettingParameter) -> any SettingControllable
}

public final class SettingBuilder: Builder<SettingDependency>, SettingBuildable {
    public func build(with parameter: SettingParameter) -> any SettingControllable {
        let noticeListBuilder = NoticeListBuilder(dependency)
        let myCodesBuilder = MyCodesBuilder(dependency)
        let blockedCodesBuilder = BlockedCodesBuilder(dependency)
        let openSourceLicenseListBuilder = OpenSourceLicenseListBuilder(dependency)
        
        let router = SettingRouter(
            settingBuilder: self,
            noticeListBuilder: noticeListBuilder,
            myCodesBuilder: myCodesBuilder,
            blockedCodesBuilder: blockedCodesBuilder,
            openSourceLicenseListBuilder: openSourceLicenseListBuilder
        )
        let reducer = Reducer(SettingViewReduce(
            codeService: dependency.codeService
        ))
        let viewController = SettingViewController(
            router: router,
            reducer: reducer,
            menus: parameter.menus
        )
        
        return viewController
    }
}
