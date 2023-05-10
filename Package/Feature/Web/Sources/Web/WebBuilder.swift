//
//  WebBuilder.swift
//  
//
//  Created by JSilver on 2023/03/24.
//

import Foundation
import RVB
import Reducer

public protocol WebDependency: Dependency {
    
}

public struct WebParameter: Parameter {
    // MARK: - Property
    let url: URL
    
    // MARK: - Initializer
    public init(url: URL) {
        self.url = url
    }
}

public protocol WebBuildable: Buildable {
    func build(with parameter: WebParameter) -> WebControllable
}

public final class WebBuilder: Builder<WebDependency>, WebBuildable {
    public func build(with parameter: WebParameter) -> WebControllable {
        let router = WebRouter(
            webBuilder: self
        )
        let reducer = Reducer(WebViewReduce())
        let viewController = WebViewController(
            router: router,
            reducer: reducer,
            url: parameter.url
        )
        
        return viewController
    }
}
