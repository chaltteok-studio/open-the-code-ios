//
//  Menus+Preset.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import TCUIKit
import Environment

extension Menus {
    static func setting(action: @escaping (MenuType) -> Void) -> Menus {
        Menus(TR.Localization.settingTitle) {
            MenuSection(TR.Localization.settingSectionHelpsTitle) {
                Menu(TR.Localization.settingMenuNoticeTitle) {
                    action(.notice)
                }
                Menu(TR.Localization.settingMenuVersionTitle, description: Env.Constant.version?.string())
                Menu(TR.Localization.settingMenuDeveloperTitle, description: TR.Localization.teamName) {
                    action(.developer)
                }
                Menu(TR.Localization.settingMenuOpenSourceLicenseTitle) {
                    action(.openSourceLicense)
                }
            }

            MenuSection(TR.Localization.settingSectionMenusTitle) {
                Menu(TR.Localization.settingMenuMyCodesTitle) {
                    action(.myCode)
                }
                Menu(TR.Localization.settingMenuBlockedCodesTitle) {
                    action(.blockedCode)
                }
                Menu(TR.Localization.settingMenuGetKeyTitle) {
                    action(.getKey)
                }
            }
        }
    }
}
