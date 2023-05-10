//
//  ErrorAlertRepresentable.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import Foundation
import Resource
import API
import CodeService

protocol ErrorAlertRepresentable {
    var title: String? { get }
    var description: String? { get }
}

// MARK: - CSError
extension CSError: ErrorAlertRepresentable { }

// MARK: - CodeServiceError
extension CodeServiceError: ErrorAlertRepresentable {
    var title: String? {
        switch self {
        case .unknown:
            return TR.Localization.errorAlertDescription
            
        case .keyNotEnough:
            return TR.Localization.errorCodeServiceKeyNotEnoughTitle
            
        case .keyNotFound:
            return TR.Localization.errorCodeServiceKeyNotFoundTitle
            
        case .blockedKey:
            return TR.Localization.errorCodeServiceCodeBlockedTitle
        }
    }
    
    var description: String? {
        switch self {
        case .unknown:
            return TR.Localization.errorAlertTitle
            
        case .keyNotEnough:
            return TR.Localization.errorCodeServiceKeyNotEnoughDescription
            
        case .keyNotFound:
            return TR.Localization.errorCodeServiceKeyNotFoundDescription
            
        case .blockedKey:
            return TR.Localization.errorCodeServiceCodeBlockedDescription
        }
    }
}
