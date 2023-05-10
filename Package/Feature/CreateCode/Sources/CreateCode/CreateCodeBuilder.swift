//
//  CreateCodeBuilder.swift
//  
//
//  Created by JSilver on 2023/03/14.
//

import RVB
import Reducer
import CodeService

public protocol CreateCodeDependency: Dependency {
    var codeService: any CodeServiceable { get }
}

public struct CreateCodeParameter: Parameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol CreateCodeBuildable: Buildable {
    func build(with parameter: CreateCodeParameter) -> any CreateCodeControllable
}

public final class CreateCodeBuilder: Builder<CreateCodeDependency>, CreateCodeBuildable {
    public func build(with parameter: CreateCodeParameter) -> any CreateCodeControllable {
        let router = CreateCodeRouter()
        let reducer = Reducer(CreateCodeViewReduce(
            codeService: dependency.codeService
        ))
        let viewController = CreateCodeViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
