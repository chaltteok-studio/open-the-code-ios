//
//  Environment.swift
//  
//
//  Created by jsilver on 2022/02/01.
//

import Foundation

public typealias Env = Environment

public enum Environment { }

public extension Environment {
    enum Configuration {
        case develop
        case live
        case deploy
    }
    
    /// Current application build configuration state.
    static var config: Configuration = .deploy
}

public extension Environment {
    enum Locale: String {
        case ko
        case en
        
        public init(_ locale: Foundation.Locale) {
            let id: String?
            if #available(iOS 16.0, *) {
                id = locale.language.languageCode?.identifier
            } else {
                id = locale.languageCode
            }
            
            switch id {
            case "ko":
                self = .ko
                
            default:
                self = .en
            }
        }
    }

    /// Current application locale state.
    static var locale: Locale { .init(Foundation.Locale.current) }
}
