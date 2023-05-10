//
//  NoticesTarget.swift
//  
//
//  Created by JSilver on 2023/03/21.
//

import Foundation
import Environment
import Network

public struct NoticesTarget: TCStaticTarget {
    // MARK: - Property
    public var path: String {
        "/the-code/notices/v1?locale=\(Env.locale.rawValue)"
    }
    
    public var method: HTTPMethod { .get }
    public var transaction: Transaction { .data }
    public var request: Request { .none }
    public let parameter: Parameter
    
    public var result: Mapper<Result> { .codable }
    public var error: Mapper<Error> { .none }
    
    // MARK: - Initializer
    public init(_ parameter: Parameter) {
        self.parameter = parameter
    }
}

public extension NoticesTarget {
    struct Parameter {
        // MARK: - Property
        
        // MARK: - Initializer
        public init() { }
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    struct Result: Decodable {
        enum CodingKeys: CodingKey {
            case notices
        }
        
        // MARK: - Property
        public let notices: [Notice]
        
        // MARK: - Initializer
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            self.notices = try container.decode([Notice].self)
        }
        
        // MARK: - Lifecycle
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    struct Notice: Decodable {
        // MARK: - Property
        enum CodingKeys: CodingKey {
            case id
            case url
            case title
            case createdAt
        }
        
        public let id: String
        public let url: String
        public let title: String
        public let createdAt: Date
        
        // MARK: - Initializer
        
        // MARK: - Lifecycle
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: .id)
            self.url = try container.decode(String.self, forKey: .url)
            self.title = try container.decode(String.self, forKey: .title)
            
            guard let dateMilliseconds = try TimeInterval(container.decode(String.self, forKey: .createdAt))
            else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.createdAt], debugDescription: "Fail to convert Date from String"))
            }
            self.createdAt = Date(timeIntervalSince1970: dateMilliseconds)
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
}
