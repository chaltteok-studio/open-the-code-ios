//
//  WebRouter.swift
//  
//
//  Created by JSilver on 2023/03/24.
//

import RVB

protocol WebRoutable: Routable {
    func routeToWeb(with parameter: WebParameter) -> any WebControllable
}

final class WebRouter: WebRoutable {
    // MARK: - Property
    private let webBuilder: any WebBuildable
    
    // MARK: - Initializer
    init(webBuilder: any WebBuildable) {
        self.webBuilder = webBuilder
    }
    
    // MARK: - Public
    func routeToWeb(with parameter: WebParameter) -> any WebControllable {
        webBuilder.build(with: parameter)
    }

    // MARK: - Private
}
