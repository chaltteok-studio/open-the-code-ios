//
//  GetCodesConfigInfoSpec.swift
//  
//
//  Created by JSilver on 2023/04/14.
//

import Foundation
import Environment
import Dyson

public struct GetCodesConfigInfoSpec: CSSpec {
    // MARK: - Property
    public var path: String { "/the-code/codes/config/info" }
    
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

public extension GetCodesConfigInfoSpec {
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
        public let count: Int
        
        // MARK: - Initializer
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
}
