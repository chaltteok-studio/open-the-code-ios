//
//  Date+Format.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import Foundation

public extension Date {
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
