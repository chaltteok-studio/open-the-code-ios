//
//  Resource+Font.swift
//  
//
//  Created by JSilver on 2023/03/06.
//

import UIKit

public extension R {
    enum Font { }
}

public extension R.Font {
    static func registerFonts() {
        guard let url = Bundle.module.url(forResource: "neodgm", withExtension: "ttf") else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    
    static func neoDunggeunmo(ofSize fontSize: CGFloat) -> UIFont? {
        .init(name: "NeoDunggeunmo", size: fontSize)
    }
}
