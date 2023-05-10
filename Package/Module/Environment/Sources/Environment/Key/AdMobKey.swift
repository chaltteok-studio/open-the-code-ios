//
//  AdMobKey.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import Foundation

public typealias AdMobKey = Environment.Key.AdMob

public extension Environment.Key {
    struct AdMob: Equatable {
        // MARK: - Property
        public let rawValue: String
        public let description: String?
        
        // MARK: - Initializer
        public init(_ rawValue: String, description: String? = nil) {
            self.rawValue = rawValue
            self.description = description
        }
        
        // MARK: - Public
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
        
        // MARK: - Private
    }
}

public extension Environment.Key.AdMob {
    static let nativeTest = AdMobKey("ca-app-pub-3940256099942544/3986624511", description: "Google AdMob native banner test key.")
    static let rewardTest = AdMobKey("ca-app-pub-3940256099942544/1712485313", description: "Google AdMob reward ad test key.")
    
    static let mainBanner = nativeTest
    static let roomBanner = nativeTest
    static let codeKeyReward = rewardTest
}
