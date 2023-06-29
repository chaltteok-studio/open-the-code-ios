//
//  CreateCodeSpec.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Environment
import Dyson

public struct CreateCodeSpec: CSSpec {
    // MARK: - Property
    public var path: String { "/the-code/codes" }
    
    public var method: HTTPMethod { .post }
    public var transaction: Transaction { .data }
    public var request: Request { .body(parameter, encoder: .codable) }
    public let parameter: Parameter
    
    public var result: Mapper<Result> { .codable }
    public var error: Mapper<CSError> { .codable }
    
    // MARK: - Initializer
    public init(_ parameter: Parameter) {
        self.parameter = parameter
    }
}

public extension CreateCodeSpec {
    struct Parameter: Encodable {
        // MARK: - Property
        public let code: String
        public let author: String
        public let content: String
        
        // MARK: - Initializer
        public init(
            code: String,
            author: String,
            content: String
        ) {
            self.code = code
            self.author = author
            self.content = content
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
