//
//  DeleteCodeTarget.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Environment
import Network

public struct DeleteCodeTarget: CSTarget {
    // MARK: - Property
    public var path: String { "/the-code/codes/\(parameter.code)" }
    
    public var method: HTTPMethod { .delete }
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

public extension DeleteCodeTarget {
    struct Parameter: Encodable {
        // MARK: - Property
        public let code: String
        
        // MARK: - Initializer
        public init(code: String) {
            self.code = code
        }
        
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
