//
//  EnterCodeBuilder.swift
//  
//
//  Created by JSilver on 2023/01/29.
//

import RVB
import Reducer
import CodeService
import Room

public protocol EnterCodeDependency: Dependency, RoomDependency {
    var codeService: any CodeServiceable { get }
}

public struct EnterCodeParameter: Parameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol EnterCodeBuildable: Buildable {
    func build(with parameter: EnterCodeParameter) -> any EnterCodeControllable
}

public final class EnterCodeBuilder: Builder<EnterCodeDependency>, EnterCodeBuildable {
    public func build(with parameter: EnterCodeParameter) -> any EnterCodeControllable {
        let roomBuilder = RoomBuilder(dependency)
        
        let router = EnterCodeRouter(
            roomBuilder: roomBuilder
        )
        let reducer = Reducer(EnterCodeViewReduce(
            codeService: dependency.codeService
        ))
        let viewController = EnterCodeViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
