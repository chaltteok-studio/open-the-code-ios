//
//  Notice.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import Service

public struct Notice {
    public let id: String
    public let url: String
    public let title: String
    public let createdAt: Date
    
    public init(
        id: String,
        url: String,
        title: String,
        date: Date
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.createdAt = date
    }
}

extension Notice {
    init(_ notice: NoticesSpec.Notice) {
        self.init(
            id: notice.id,
            url: notice.url,
            title: notice.title,
            date: notice.createdAt
        )
    }
}
