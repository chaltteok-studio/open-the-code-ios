//
//  Environment+URL.swift
//  
//
//  Created by jsilver on 2022/02/02.
//

import Foundation

public extension Environment {
    enum URL { }
}

public extension Environment.URL {
    static var baseURL: String {
        "********"
    }
    
    static var staticURL: String {
        switch Env.config {
        case .develop:
            return "https://raw.githubusercontent.com/chaltteok-studio/chaltteok-static-server/develop"
            
        case .live,
             .deploy:
            return "https://raw.githubusercontent.com/chaltteok-studio/chaltteok-static-server/live"
        }
    }
    
    static var appStoreURL: String {
        "itms-apps://itunes.apple.com/app/apple-store/id6447828226?mt=8"
    }
}
