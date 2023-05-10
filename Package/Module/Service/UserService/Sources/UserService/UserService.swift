//
//  UserService.swift
//
//
//  Created by JSilver on 2023/03/26.
//

import Service

public protocol UserServiceable {
    var userIdentifier: String { get }
}

public class UserService: UserServiceable {
    // MARK: - Property
    @Store
    private var uuid: String?
    
    public var userIdentifier: String {
        guard let uuid else {
            let uuid = UUID().uuidString
            self.uuid = uuid
            
            return uuid
        }
        
        return uuid
    }
    
    // MARK: - Initializer
    public init(storage: any Storage) {
        // Set stored date.
        self._uuid = .init(storage, for: .uuid)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
