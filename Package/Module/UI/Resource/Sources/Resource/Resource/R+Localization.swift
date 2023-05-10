//
//  Resourece+Localization.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import Foundation
import ChapssalKit

public extension R {
    enum Localization { }
}

public extension R.Localization {
    // MARK: - Common
    static var appName: String { "app_name".localized(in: .module) }
    static var teamName: String { "team_name".localized(in: .module) }
    static var copyright: String { "copyright".localized(in: .module) }
    
    static var emptyTitle: String { "empty_title".localized(in: .module) }
    static var emptyDescription: String { "empty_description".localized(in: .module) }
    
    static var errorAlertTitle: String { "error_alert_title".localized(in: .module) }
    static var errorAlertDescription: String { "error_alert_description".localized(in: .module) }
    static var errorAlertActionCancelTitle: String { "error_alert_action_cancel_title".localized(in: .module) }
    static var errorAlertActionConfirmTitle: String { "error_alert_action_confirm_title".localized(in: .module) }
    
    // MARK: - Error
    static var errorLimitAPICallTitle: String { "error_limit_api_call_title".localized(in: .module) }
    static var errorLimitAPICallDescription: String { "error_limit_api_call_description".localized(in: .module) }
    static var errorCodeServiceKeyNotEnoughTitle: String { "error_code_service_key_not_enough_title".localized(in: .module) }
    static var errorCodeServiceKeyNotEnoughDescription: String { "error_code_service_key_not_enough_description".localized(in: .module) }
    static var errorCodeServiceKeyNotFoundTitle: String { "error_code_service_key_not_found_title".localized(in: .module) }
    static var errorCodeServiceKeyNotFoundDescription: String { "error_code_service_key_not_found_description".localized(in: .module) }
    static var errorCodeServiceCodeBlockedTitle: String { "error_code_service_code_blocked_title".localized(in: .module) }
    static var errorCodeServiceCodeBlockedDescription: String { "error_code_service_code_blocked_description".localized(in: .module) }
    
    // MARK: - Launch
    static var launchUnsupportedVersionAlertTitle: String { "launch_unsupported_version_alert_title".localized(in: .module) }
    static var launchUnsupportedVersionAlertDescription: String { "launch_unsupported_version_alert_description".localized(in: .module) }
    static var launchUnsupportedVersionAlertCctionUpdateTitle: String { "launch_unsupported_version_alert_action_update_title".localized(in: .module) }
    
    // MARK: - Enter Code
    static var enterCodeTotalCodesCountTitle: String { "enter_code_total_codes_count_title".localized(in: .module) }
    static var enterCodeCodeInputTitle: String { "enter_code_code_input_title".localized(in: .module) }
    static var enterCodeCodeInputPlaceholder: String { "enter_code_code_input_placeholder".localized(in: .module) }
    static var enterCodeEnterButtonTitle: String { "enter_code_enter_button_title".localized(in: .module) }
    
    // MARK: - Create Code
    static var createCodeCodeInputTitle: String { "create_code_code_input_title".localized(in: .module) }
    static var createCodeCodeInputPlaceholder: String { "create_code_code_input_placeholder".localized(in: .module) }
    static var createCodeGenerateCodeButtonTitle: String { "create_code_generate_code_button_title".localized(in: .module) }
    static var createCodeDescriptionInputTitle: String { "create_code_description_input_title".localized(in: .module) }
    static var createCodeDescriptionInputPlaceholder: String { "create_code_description_input_placeholder".localized(in: .module) }
    static var createCodeCreateButtonTitle: String { "create_code_create_button_title".localized(in: .module) }
    static var createCodeCreatedAlertTitle: String { "create_code_created_alert_title".localized(in: .module) }
    static var createCodeCreatedAlertDescription: String { "create_code_created_alert_description".localized(in: .module) }
    static var createCodeCreateTermTitle: String { "create_code_create_term_title".localized(in: .module) }
    
    // MARK: - Room
    static var roomCodeCopyToastTitle: String { "room_code_copy_toast_title".localized(in: .module) }
    static var roomCodeDeleteButtonTitle: String { "room_code_delete_button_title".localized(in: .module) }
    static var roomCodeDeletedAlertTitle: String { "room_code_deleted_alert_title".localized(in: .module) }
    static var roomCodeDeletedAlertDescription: String { "room_code_deleted_alert_description".localized(in: .module) }
    static var roomCodeBlockButtonTitle: String { "room_code_block_button_title".localized(in: .module) }
    static var roomCodeBlockConfirmAlertTitle: String { "room_code_block_confirm_alert_title".localized(in: .module) }
    static var roomCodeBlockConfirmAlertDescription: String { "room_code_block_confirm_alert_description".localized(in: .module) }
    static var roomCodeBlockConfirmAlertActionBlockTitle: String { "room_code_block_confirm_alert_action_block_title".localized(in: .module) }
    static var roomCodeBlockedAlertTitle: String { "room_code_blocked_alert_title".localized(in: .module) }
    static var roomCodeBlockedAlertDescription: String { "room_code_blocked_alert_description".localized(in: .module) }
    static var roomReportSubject: String { "room_report_subject".localized(in: .module) }
    static var roomReportMessage: String { "room_report_message".localized(in: .module) }
    
    static var loadingCodeDecryption1: String { "loading_code_decryption_1".localized(in: .module) }
    static var loadingCodeDecryption2: String { "loading_code_decryption_2".localized(in: .module) }
    static var loadingCodeDecryption3: String { "loading_code_decryption_3".localized(in: .module) }
    static var loadingCodeDecryption4: String { "loading_code_decryption_4".localized(in: .module) }
    static var loadingCodeDecryption5: String { "loading_code_decryption_5".localized(in: .module) }
    static var loadingCodeDecryption6: String { "loading_code_decryption_6".localized(in: .module) }
    static var loadingCodeDecryption7: String { "loading_code_decryption_7".localized(in: .module) }
    static var loadingCodeDecryption8: String { "loading_code_decryption_8".localized(in: .module) }
    static var loadingCodeDecryption9: String { "loading_code_decryption_9".localized(in: .module) }
    static var loadingCodeDecryption10: String { "loading_code_decryption_10".localized(in: .module) }
    static var loadingCodeDecryption11: String { "loading_code_decryption_11".localized(in: .module) }
    static var loadingCodeDecryption12: String { "loading_code_decryption_12".localized(in: .module) }
    static var loadingCodeDecryption13: String { "loading_code_decryption_13".localized(in: .module) }
    static var loadingCodeDecryption14: String { "loading_code_decryption_14".localized(in: .module) }
    static var loadingCodeDecryption15: String { "loading_code_decryption_15".localized(in: .module) }
    static var loadingCodeDecryption16: String { "loading_code_decryption_16".localized(in: .module) }
    static var loadingCodeDecryption17: String { "loading_code_decryption_17".localized(in: .module) }
    static var loadingCodeDecryption18: String { "loading_code_decryption_18".localized(in: .module) }
    static var loadingCodeDecryption19: String { "loading_code_decryption_19".localized(in: .module) }
    static var loadingCodeDecryption20: String { "loading_code_decryption_20".localized(in: .module) }
    static var loadingCodeDecryption21: String { "loading_code_decryption_21".localized(in: .module) }
    static var loadingCodeDecryption22: String { "loading_code_decryption_22".localized(in: .module) }
    static var loadingCodeDecryption23: String { "loading_code_decryption_23".localized(in: .module) }
    static var loadingCodeDecryption24: String { "loading_code_decryption_24".localized(in: .module) }
    static var loadingCodeDecryption25: String { "loading_code_decryption_25".localized(in: .module) }
    static var loadingCodeDecryption26: String { "loading_code_decryption_26".localized(in: .module) }
    
    // MARK: - Setting
    static var settingTitle: String { "setting_title".localized(in: .module) }
    static var settingSectionHelpsTitle: String { "setting_section_helps_title".localized(in: .module) }
    static var settingMenuNoticeTitle: String { "setting_menu_notice_title".localized(in: .module) }
    static var settingMenuVersionTitle: String { "setting_menu_version_title".localized(in: .module) }
    static var settingMenuDeveloperTitle: String { "setting_menu_developer_title".localized(in: .module) }
    static var settingMenuOpenSourceLicenseTitle: String { "setting_menu_open_source_license_title".localized(in: .module) }
    static var settingSectionMenusTitle: String { "setting_section_menus_title".localized(in: .module) }
    static var settingMenuMyCodesTitle: String { "setting_menu_my_codes_title".localized(in: .module) }
    static var settingMenuBlockedCodesTitle: String { "setting_menu_blocked_codes_title".localized(in: .module) }
    static var settingMenuGetKeyTitle: String { "setting_menu_get_key_title".localized(in: .module) }
    static var settingToastCopiedDeveloper: String { "setting_toast_copied_developer".localized(in: .module) }
    
    // MARK: - Notice
    static var noticeTitle: String { "notice_title".localized(in: .module) }
    
    // MARK: - My Codes
    static var myCodesTitle: String { "my_codes_title".localized(in: .module) }
    
    // MARK: - Blocked Codes
    static var blockedCodesTitle: String { "blocked_codes_title".localized(in: .module) }
    static var blockedCodesUnblockConfirmAlertTitle: String { "blocked_codes_unblock_confirm_alert_title".localized(in: .module) }
    static var blockedCodesUnblockConfirmAlertDescription: String { "blocked_codes_unblock_confirm_alert_description".localized(in: .module) }
    static var blockedCodesUnblockConfirmAlertActionUnblockTitle: String { "blocked_codes_unblock_confirm_alert_action_unblock_title".localized(in: .module) }
    
    // MARK: - Open Source License
    static var openSourceLicenseTitle: String { "open_source_license_title".localized(in: .module) }
    
    // MARK: - Web
    static var webLoadingTitle: String { "web_loading_title".localized(in: .module) }
}
