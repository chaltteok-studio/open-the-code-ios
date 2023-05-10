//
//  GetCodeTarget.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Environment
import Network

public struct GetCodeTarget: CSTarget {
    // MARK: - Property
    public var path: String { "/the-code/codes/\(parameter.code)" }
    
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

public extension GetCodeTarget {
    struct Parameter {
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
        public enum CodingKeys: String, CodingKey {
            case code
            case author
            case createdAt = "created_at"
            case requestedAt = "requested_at"
            case content
        }
        
        // MARK: - Property
        public let code: String
        public let author: String
        public let createdAt: Date
        public let requestedAt: Date
        public let content: String
        
        // MARK: - Initializer
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.code = try container.decode(String.self, forKey: .code)
            self.author = try container.decode(String.self, forKey: .author)
            
            guard let createdTimestamp = TimeInterval(try container.decode(String.self, forKey: .createdAt))
            else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.createdAt], debugDescription: "Fail to convert Date from String"))
            }
            self.createdAt = Date(timeIntervalSince1970: createdTimestamp)
            guard let requestedTimestamp = TimeInterval(try container.decode(String.self, forKey: .requestedAt))
            else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: [CodingKeys.requestedAt],
                    debugDescription: "Fail to convert Date from String"
                ))
            }
            self.requestedAt = Date(timeIntervalSince1970: requestedTimestamp / 1000)
            self.content = try container.decode(String.self, forKey: .content)
        }
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
}
