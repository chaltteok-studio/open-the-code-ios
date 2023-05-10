//
//  OpenSourceLicenseListBuilder.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import RVB
import Reducer

public protocol OpenSourceLicenseListDependency: Dependency, OpenSourceLicenseDetailDependency {
    
}

public struct OpenSourceLicenseListParameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol OpenSourceLicenseListBuildable: Buildable {
    func build(with parameter: OpenSourceLicenseListParameter) -> any OpenSourceLicenseListControllable
}

public final class OpenSourceLicenseListBuilder: Builder<OpenSourceLicenseListDependency>, OpenSourceLicenseListBuildable {
    public func build(with parameter: OpenSourceLicenseListParameter) -> any OpenSourceLicenseListControllable {
        let openSourceLicenseDetailBuilder = OpenSourceLicenseDetailBuilder(dependency)
        
        let router = OpenSourceLicenseListRouter(
            openSourceLicenseDetailBuilder: openSourceLicenseDetailBuilder
        )
        let reducer = Reducer(OpenSourceLicenseListViewReduce())
        let viewController = OpenSourceLicenseListViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
