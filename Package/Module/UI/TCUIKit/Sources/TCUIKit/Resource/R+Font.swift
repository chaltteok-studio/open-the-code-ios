//
//  R+Font.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import UIKit
import Resource

public extension TR.Font {
    static func font(ofSize fontSize: CGFloat) -> UIFont {
        TR.Font.neoDunggeunmo(ofSize: fontSize) ?? CR.Font.font(ofSize: fontSize, weight: .regular)
    }
}
