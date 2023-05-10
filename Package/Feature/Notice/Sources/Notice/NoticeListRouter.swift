//
//  NoticeListRouter.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import RVB
import Web

protocol NoticeListRoutable: Routable {
    func routeToWeb(with parameter: WebParameter) -> any WebControllable
}

final class NoticeListRouter: NoticeListRoutable {
    // MARK: - Property
    private let webBuilder: WebBuildable
    
    // MARK: - Initializer
    init(webBuilder: WebBuildable) {
        self.webBuilder = webBuilder
    }
    
    // MARK: - Public
    func routeToWeb(with parameter: WebParameter) -> any WebControllable {
        webBuilder.build(with: parameter)
    }

    // MARK: - Private
}
