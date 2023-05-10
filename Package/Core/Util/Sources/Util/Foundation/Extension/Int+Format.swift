//
//  Int+Format.swift
//  
//
//  Created by JSilver on 2023/04/14.
//

import Foundation

public extension Int {
    var number: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}
