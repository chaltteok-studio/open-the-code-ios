//
//  Code.swift
//  
//
//  Created by JSilver on 2023/03/27.
//

import Service

public struct Code {
    // MARK: - Property
    public let code: String
    public let author: String
    public let createdAt: Date
    public let content: String
    
    // MARK: - Initializer
    public init(
        code: String,
        author: String,
        createdAt: Date,
        content: String
    ) {
        self.code = code
        self.author = author
        self.createdAt = createdAt
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

extension Code {
    init(_ code: GetCodeSpec.Result) {
        self.init(
            code: code.code,
            author: code.author,
            createdAt: code.createdAt,
            content: code.content
        )
    }
}

extension Code {
    init(_ code: GetCodesSpec.Code) {
        self.init(
            code: code.code,
            author: code.author,
            createdAt: code.createdAt,
            content: code.content
        )
    }
}
