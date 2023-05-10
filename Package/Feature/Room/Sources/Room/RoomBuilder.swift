//
//  RoomBuilder.swift
//  
//
//  Created by JSilver on 2023/03/17.
//

import RVB
import Reducer
import UserService
import CodeService

public protocol RoomDependency: Dependency {
    var userService: any UserServiceable { get }
    var codeService: any CodeServiceable { get }
}

public struct RoomParameter: Parameter {
    // MARK: - Property
    let code: Code
    
    // MARK: - Initializer
    public init(code: Code) {
        self.code = code
    }
}

public protocol RoomBuildable: Buildable {
    func build(with parameter: RoomParameter) -> any RoomControllable
}

public final class RoomBuilder: Builder<RoomDependency>, RoomBuildable {
    public func build(with parameter: RoomParameter) -> any RoomControllable {
        let router = RoomRouter()
        let reducer = Reducer(RoomViewReduce(
            userService: dependency.userService,
            codeService: dependency.codeService,
            code: parameter.code
        ))
        let viewController = RoomViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
