//
//  NoticeListBuilder.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import RVB
import Reducer
import AppService
import Web

public protocol NoticeListDependency: Dependency, WebDependency {
    var appService: any AppServiceable { get }
}

public struct NoticeListParameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol NoticeListBuildable: Buildable {
    func build(with parameter: NoticeListParameter) -> any NoticeListControllable
}

public final class NoticeListBuilder: Builder<NoticeListDependency>, NoticeListBuildable {
    public func build(with parameter: NoticeListParameter) -> any NoticeListControllable {
        let webBuilder = WebBuilder(dependency)
        
        let router = NoticeListRouter(
            webBuilder: webBuilder
        )
        let reducer = Reducer(NoticeListViewReduce(
            appService: dependency.appService
        ))
        let viewController = NoticeListViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
