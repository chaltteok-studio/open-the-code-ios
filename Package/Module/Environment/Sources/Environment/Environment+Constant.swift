//
//  Environment+Constant.swift
//  
//
//  Created by JSilver on 2023/03/17.
//

import Foundation
import Util
import Resource

public extension Environment {
    enum Constant { }
}

public extension Environment.Constant {
    static var version: Version? {
        guard let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return nil }
        return Version(versionString)
    }
    static var csEmail: String { "chaltteok.thecode@gmail.com" }
    
    static let generateCodeSet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "{", "}", "[", "]", ":", ";", "<", ">", ",", ".", "?", "-"]
    static func codeRegex(count: Int) -> String {
        "^[\\wㄱ-ㅎ|ㅏ-ㅣ|가-힣!@#$%^&*()_+{}\\[\\]:;<>,.?-]{0,\(count)}$"
    }
    
    static let codeDecryptionTexts = [
        R.Localization.loadingCodeDecryption1,
        R.Localization.loadingCodeDecryption2,
        R.Localization.loadingCodeDecryption3,
        R.Localization.loadingCodeDecryption4,
        R.Localization.loadingCodeDecryption5,
        R.Localization.loadingCodeDecryption6,
        R.Localization.loadingCodeDecryption7,
        R.Localization.loadingCodeDecryption8,
        R.Localization.loadingCodeDecryption9,
        R.Localization.loadingCodeDecryption10,
        R.Localization.loadingCodeDecryption11,
        R.Localization.loadingCodeDecryption12,
        R.Localization.loadingCodeDecryption13,
        R.Localization.loadingCodeDecryption14,
        R.Localization.loadingCodeDecryption15,
        R.Localization.loadingCodeDecryption16,
        R.Localization.loadingCodeDecryption17,
        R.Localization.loadingCodeDecryption18,
        R.Localization.loadingCodeDecryption19,
        R.Localization.loadingCodeDecryption20,
        R.Localization.loadingCodeDecryption21,
        R.Localization.loadingCodeDecryption22,
        R.Localization.loadingCodeDecryption23,
        R.Localization.loadingCodeDecryption24,
        R.Localization.loadingCodeDecryption25,
        R.Localization.loadingCodeDecryption26
    ]
}
