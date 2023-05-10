//
//  Resource+Image.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import UIKit

public extension R {
    enum Image { }
}

public extension R.Image {
    static var appIcon: UIImage { UIImage(named: "app_icon", in: .module, compatibleWith: nil)! }
    
    static var lock: UIImage { UIImage(named: "lock", in: .module, compatibleWith: nil)! }
}
