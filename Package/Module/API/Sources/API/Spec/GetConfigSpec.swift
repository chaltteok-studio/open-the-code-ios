//
//  GetConfigSpec.swift
//
//
//  Created by JSilver on 2023/03/30.
//

import Foundation
import Environment
import Dyson

public struct GetConfigSpec: TCStaticSpec {
    // MARK: - Property
    public var path: String { "/the-code/common/config/v1" }
    
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

public extension GetConfigSpec {
    struct Parameter {
        // MARK: - Property
        
        // MARK: - Initializer
        public init() { }
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    struct Result: Decodable {
        enum CodingKeys: String, CodingKey {
            case limitAPICall = "limit_api_call"
            case minimumVersion = "minimum_version"
        }
        
        // MARK: - Property
        public let limitAPICall: Bool
        public let minimumVersion: String
        
        // MARK: - Initializer
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
}
