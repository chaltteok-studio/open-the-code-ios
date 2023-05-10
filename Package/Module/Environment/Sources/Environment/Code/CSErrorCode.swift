//
//  CSErrorCode.swift
//  
//
//  Created by jsilver on 2022/02/01.
//

import Foundation

public typealias CSErrorCode = Environment.Code.CSError

public extension Environment.Code {
    struct CSError: Decodable, Equatable {
        // MARK: - Property
        public let rawValue: String
        public let description: String?
        
        // MARK: - Initializer
        public init(_ rawValue: String, description: String? = nil) {
            self.rawValue = rawValue
            self.description = description
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let code = try container.decode(String.self)
            
            self.init(code)
        }
        
        // MARK: - Public
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
        
        // MARK: - Private
    }
}

public extension Environment.Code.CSError {
    static let CS99999 = CSErrorCode("CS99999", description: "API calls have been restricted.")
    
    static let CS00000 = CSErrorCode("CS00000", description: "Unknown error.")
    static let CS00001 = CSErrorCode("CS00000", description: "Missing required fields.")
    static let CS10000 = CSErrorCode("CS10000", description: "The code not found.")
    static let CS10001 = CSErrorCode("CS10001", description: "Failed to generate code due to code duplication.")
}
