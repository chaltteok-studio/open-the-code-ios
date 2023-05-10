//
//  BlockedCodesBuilder.swift
//  
//
//  Created by JSilver on 2023/05/08.
//

import RVB
import Reducer
import CodeService

public protocol BlockedCodesDependency: Dependency {
    var codeService: any CodeServiceable { get }
}

public struct BlockedCodesParameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol BlockedCodesBuildable: Buildable {
    func build(with parameter: BlockedCodesParameter) -> BlockedCodesControllable
}

public final class BlockedCodesBuilder: Builder<BlockedCodesDependency>, BlockedCodesBuildable {
    public func build(with parameter: BlockedCodesParameter) -> BlockedCodesControllable {
        let router = BlockedCodesRouter()
        let reducer = Reducer(BlockedCodesViewReduce(
            codeService: dependency.codeService
        ))
        let viewController = BlockedCodesViewController(
            router: router,
            reducer: reducer
        )
        
        return viewController
    }
}
