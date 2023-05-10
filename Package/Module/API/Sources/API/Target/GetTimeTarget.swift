//
//  GetTimeTarget.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import Foundation
import Environment
import Network

public struct GetTimeTarget: TCStaticTarget {
    // MARK: - Property
    public var path: String { "/the-code/common/time/v1" }
    
    public var method: HTTPMethod { .get }
    public var transaction: Transaction { .data }
    public var request: Request { .none }
    public let parameter: Parameter
    
    public var result: Mapper<Result> { .codable }
    public var error: Mapper<CSError> { .codable }
    
    // MARK: - Initializer
    public init(_ parameter: Parameter) {
        self.parameter = parameter
    }
}

public extension GetTimeTarget {
    struct Parameter {
        // MARK: - Property
        
        // MARK: - Initializer
        public init() { }
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    struct Result: Decodable {
        // MARK: - Property
        
        // MARK: - Initializer
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
}
