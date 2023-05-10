//
//  CSError.swift
//
//
//  Created by jsilver on 2022/01/27.
//

import Foundation
import Environment

public struct CSError: Error, Decodable, Equatable {
    enum CodingKeys: CodingKey {
        case code
        case title
        case description
        case timestamp
    }
    
    // MARK: - Property
    public let code: CSErrorCode
    public let title: String?
    public let description: String?
    public let timestamp: Date
    
    // MARK: - Initializer
    public init(
        code: CSErrorCode,
        title: String? = nil,
        description: String? = nil,
        timestamp: Date = .now
    ) {
        self.code = code
        self.title = title
        self.description = description
        self.timestamp = timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try container.decode(CSErrorCode.self, forKey: .code)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        guard let timestamp = TimeInterval(try container.decode(String.self, forKey: .timestamp))
        else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: [CodingKeys.timestamp],
                debugDescription: "Fail to convert Date from String"
            ))
        }
        self.timestamp = Date(timeIntervalSince1970: timestamp / 1000)
    }
    
    // MARK: - Public
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.code == rhs.code
    }
    
    // MARK: - Private
}
