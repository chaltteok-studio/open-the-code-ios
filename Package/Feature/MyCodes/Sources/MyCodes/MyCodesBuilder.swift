//
//  MyCodesBuilder.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import RVB
import Reducer
import CodeService
import Room

public protocol MyCodesDependency: Dependency, RoomDependency {
    var codeService: any CodeServiceable { get }
}

public struct MyCodesParameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol MyCodesBuildable: Buildable {
    func build(with parameter: MyCodesParameter) -> MyCodesControllable
}

public final class MyCodesBuilder: Builder<MyCodesDependency>, MyCodesBuildable {
    public func build(with parameter: MyCodesParameter) -> MyCodesControllable {
        let roomBuilder = RoomBuilder(dependency)
        
        let router = MyCodesRouter(
            roomBuilder: roomBuilder
        )
        let reducer = Reducer(MyCodesViewReduce(
            codeService: dependency.codeService
        ))
        let viewController = MyCodesViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
