//
//  SettingRouter.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import RVB
import Notice
import MyCodes
import BlockedCodes
import OpenSourceLicense

protocol SettingRoutable: Routable {
    func routeToSetting(with parameter: SettingParameter) -> any SettingControllable
    func routeToNoticeList(with parameter: NoticeListParameter) -> any NoticeListControllable
    func routeToMyCodes(with parameter: MyCodesParameter) -> any MyCodesControllable
    func routeToBlockedCodes(with parameter: BlockedCodesParameter) -> any BlockedCodesControllable
    func routeToOpenSourceLicenseList(with parameter: OpenSourceLicenseListParameter) -> any OpenSourceLicenseListControllable
}

final class SettingRouter: SettingRoutable {
    // MARK: - Property
    private let settingBuilder: any SettingBuildable
    private let noticeListBuilder: any NoticeListBuildable
    private let myCodesBuilder: any MyCodesBuildable
    private let blockedCodesBuilder: any BlockedCodesBuildable
    private let openSourceLicenseBuilder: any OpenSourceLicenseListBuildable
    
    // MARK: - Initializer
    init(
        settingBuilder: any SettingBuildable,
        noticeListBuilder: any NoticeListBuildable,
        myCodesBuilder: any MyCodesBuildable,
        blockedCodesBuilder: any BlockedCodesBuildable,
        openSourceLicenseListBuilder: any OpenSourceLicenseListBuildable
    ) {
        self.settingBuilder = settingBuilder
        self.noticeListBuilder = noticeListBuilder
        self.myCodesBuilder = myCodesBuilder
        self.blockedCodesBuilder = blockedCodesBuilder
        self.openSourceLicenseBuilder = openSourceLicenseListBuilder
    }
    
    // MARK: - Public

    // MARK: - Private
    func routeToSetting(with parameter: SettingParameter) -> any SettingControllable {
        settingBuilder.build(with: parameter)
    }
    
    func routeToNoticeList(with parameter: NoticeListParameter) -> any NoticeListControllable {
        noticeListBuilder.build(with: parameter)
    }
    
    func routeToMyCodes(with parameter: MyCodesParameter) -> any MyCodesControllable {
        myCodesBuilder.build(with: parameter)
    }
    
    func routeToBlockedCodes(with parameter: BlockedCodesParameter) -> any BlockedCodesControllable {
        blockedCodesBuilder.build(with: parameter)
    }
    
    func routeToOpenSourceLicenseList(with parameter: OpenSourceLicenseListParameter) -> any OpenSourceLicenseListControllable {
        openSourceLicenseBuilder.build(with: parameter)
    }
}
