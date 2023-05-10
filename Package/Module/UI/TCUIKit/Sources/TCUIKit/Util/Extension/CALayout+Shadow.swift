//
//  CALayer+Shadow.swift
//
//
//  Created by jsilver on 2022/02/12.
//

import UIKit

public extension CALayer {
    func addShadow(color: UIColor?, offset: CGPoint, blur: CGFloat, path: CGPath? = nil) {
        shadowColor = color?.cgColor
        shadowOffset = .init(
            width: offset.x,
            height: offset.y
        )
        shadowOpacity = 1
        shadowRadius = blur
        
        if let path = path {
            shadowPath = path
        } else {
            shouldRasterize = true
            rasterizationScale = UIScreen.main.scale
        }
    }
}
