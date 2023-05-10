//
//  OpenSourceLicenseListRouter.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import RVB

protocol OpenSourceLicenseListRoutable: Routable {
    func routeToOpenSourceLicenseDetail(with parameter: OpenSourceLicenseDetailParameter) -> any OpenSourceLicenseDetailControllable
}

final class OpenSourceLicenseListRouter: OpenSourceLicenseListRoutable {
    // MARK: - Property
    private let openSourceLicenseDetailBuilder: any OpenSourceLicenseDetailBuildable
    
    // MARK: - Initializer
    init(openSourceLicenseDetailBuilder: any OpenSourceLicenseDetailBuildable) {
        self.openSourceLicenseDetailBuilder = openSourceLicenseDetailBuilder
    }
    
    // MARK: - Public

    // MARK: - Private
    func routeToOpenSourceLicenseDetail(with parameter: OpenSourceLicenseDetailParameter) -> any OpenSourceLicenseDetailControllable {
        openSourceLicenseDetailBuilder.build(with: parameter)
    }
}
