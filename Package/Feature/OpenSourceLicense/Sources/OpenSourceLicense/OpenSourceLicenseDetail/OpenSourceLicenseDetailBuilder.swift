//
//  OpenSourceLicenseDetailBuilder.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import RVB

public protocol OpenSourceLicenseDetailDependency: Dependency {
    
}

struct OpenSourceLicenseDetailParameter: Parameter {
    // MARK: - Property
    let license: License
    
    // MARK: - Initializer
    init(license: License) {
        self.license = license
    }
}

protocol OpenSourceLicenseDetailBuildable: Buildable {
    func build(with parameter: OpenSourceLicenseDetailParameter) -> any OpenSourceLicenseDetailControllable
}

final class OpenSourceLicenseDetailBuilder: Builder<OpenSourceLicenseDetailDependency>, OpenSourceLicenseDetailBuildable {
    func build(with parameter: OpenSourceLicenseDetailParameter) -> any OpenSourceLicenseDetailControllable {
        let router = OpenSourceLicenseDetailRouter()
        let viewController = OpenSourceLicenseDetailViewController(
            router: router,
            license: parameter.license
        )
        
        return viewController
    }
}
