//
//  ResourceTests.swift
//
//
//  Created by JSilver on 2023/01/28.
//

import XCTest
@testable import Resource

final class ResourceTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    // MARK: - Tests
    func test_that_load_color() throws {
        // Given
        
        // When
        
        // Then
    }
    
    func test_that_load_icon() throws {
        // Given
        
        // When
        
        // Then
    }
    
    func test_that_load_image() throws {
        // Given
        
        // When
        _ = R.Image.appIcon
        _ = R.Image.lock
        
        // Then
    }
    
    func test_that_load_localization() throws {
        // Given
        
        // When
        
        // Then
        XCTAssertNotEqual(R.Localization.appName, "unknown")
        XCTAssertNotEqual(R.Localization.teamName, "unknown")
        XCTAssertNotEqual(R.Localization.copyright, "unknown")
        
        XCTAssertNotEqual(R.Localization.emptyTitle, "unknown")
        XCTAssertNotEqual(R.Localization.emptyDescription, "unknown")
        
        XCTAssertNotEqual(R.Localization.errorAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.errorAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.errorAlertActionCancelTitle, "unknown")
        XCTAssertNotEqual(R.Localization.errorAlertActionConfirmTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.errorLimitAPICallTitle, "unknown")
        XCTAssertNotEqual(R.Localization.errorLimitAPICallDescription, "unknown")
        XCTAssertNotEqual(R.Localization.errorCodeServiceKeyNotEnoughTitle, "unknown")
        XCTAssertNotEqual(R.Localization.errorCodeServiceKeyNotEnoughDescription, "unknown")
        XCTAssertNotEqual(R.Localization.errorCodeServiceKeyNotFoundTitle, "unknown")
        XCTAssertNotEqual(R.Localization.errorCodeServiceKeyNotFoundDescription, "unknown")
        XCTAssertNotEqual(R.Localization.errorCodeServiceCodeBlockedTitle, "unknown")
        XCTAssertNotEqual(R.Localization.errorCodeServiceCodeBlockedDescription, "unknown")
        
        XCTAssertNotEqual(R.Localization.launchUnsupportedVersionAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.launchUnsupportedVersionAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.launchUnsupportedVersionAlertCctionUpdateTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.enterCodeTotalCodesCountTitle, "unknown")
        XCTAssertNotEqual(R.Localization.enterCodeCodeInputTitle, "unknown")
        XCTAssertNotEqual(R.Localization.enterCodeCodeInputPlaceholder, "unknown")
        XCTAssertNotEqual(R.Localization.enterCodeEnterButtonTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.createCodeCodeInputTitle, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeCodeInputPlaceholder, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeGenerateCodeButtonTitle, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeDescriptionInputTitle, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeDescriptionInputPlaceholder, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeCreateButtonTitle, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeCreatedAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeCreatedAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.createCodeCreateTermTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.roomCodeCopyToastTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeDeleteButtonTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeDeletedAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeDeletedAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeBlockButtonTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeBlockConfirmAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeBlockConfirmAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeBlockConfirmAlertActionBlockTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeBlockedAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.roomCodeBlockedAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.roomReportSubject, "unknown")
        XCTAssertNotEqual(R.Localization.roomReportMessage, "unknown")
        
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption1, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption2, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption3, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption4, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption5, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption6, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption7, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption8, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption9, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption10, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption11, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption12, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption13, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption14, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption15, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption16, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption17, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption18, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption19, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption20, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption21, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption22, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption23, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption24, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption25, "unknown")
        XCTAssertNotEqual(R.Localization.loadingCodeDecryption26, "unknown")
        
        XCTAssertNotEqual(R.Localization.settingTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingSectionHelpsTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuNoticeTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuVersionTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuDeveloperTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuOpenSourceLicenseTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingSectionMenusTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuMyCodesTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuBlockedCodesTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingMenuGetKeyTitle, "unknown")
        XCTAssertNotEqual(R.Localization.settingToastCopiedDeveloper, "unknown")
        
        XCTAssertNotEqual(R.Localization.noticeTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.myCodesTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.blockedCodesTitle, "unknown")
        XCTAssertNotEqual(R.Localization.blockedCodesUnblockConfirmAlertTitle, "unknown")
        XCTAssertNotEqual(R.Localization.blockedCodesUnblockConfirmAlertDescription, "unknown")
        XCTAssertNotEqual(R.Localization.blockedCodesUnblockConfirmAlertActionUnblockTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.openSourceLicenseTitle, "unknown")
        
        XCTAssertNotEqual(R.Localization.webLoadingTitle, "unknown")
    }
}
