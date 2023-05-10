//
//  MemorySecureStorage.swift
//  
//
//  Created by JSilver on 2023/02/16.
//

import Foundation
import Storage

class MemorySecureStorage: SecureStorage {
    // MARK: - Property
    var storage: [String: Data]
    
    // MARK: - Initializer
    init(storage: [String: any Codable] = [:]) {
        self.storage = storage.compactMapValues { try? JSONEncoder().encode($0) }
    }
    
    // MARK: - Public
    func create(_ data: Data, forKey key: String) throws {
        try add(.init(
            class: .genericPassword([
                .attributeAccount: key
            ]),
            value: .value([
                .valueData: data
            ])
        ))
    }
    
    func read(forKey key: String) throws -> Data {
        try match(.init(
            queries: [
                .genericPassword([
                    .attributeAccount: key
                ]),
                .match(.matchLimitOne)
            ],
            return: .return([
                .returnData: true
            ])
        ))
    }
    
    func update(_ data: Data, forKey key: String) throws {
        try update(.init(
            queries: [
                .genericPassword([
                    .attributeAccount: key
                ])
            ],
            values: [
                .value([
                    .valueData: data
                ])
            ]
        ))
    }
    
    func delete(forKey key: String) throws {
        try delete(.init(
            queries: [
                .genericPassword([
                    .attributeAccount: key
                ])
            ]
        ))
    }
    
    func add(_ item: SIAddItem) throws {
        guard let key = item.attributes[.attributeAccount] as? String,
            let data = item.attributes[.valueData] as? Data
        else {
            throw StorageError.unknown
        }
        
        guard storage[key] == nil else { throw StorageError.alreadyExsit }
        storage[key] = data
    }
    
    func match(_ item: SIMatchItem) throws -> Data {
        guard let key = item.attributes[.attributeAccount] as? String else {
            throw StorageError.unknown
        }
        
        guard let data = storage[key] else { throw StorageError.notFound }
        return data
    }
    
    func update(_ item: SIUpdateItem) throws {
        guard let key = item.queries[.attributeAccount] as? String,
            let data = item.attributes[.valueData] as? Data
        else {
            throw StorageError.unknown
        }
        
        guard storage[key] != nil else {
            throw StorageError.notFound
        }
        storage[key] = data
    }
    
    func delete(_ item: SIDeleteItem) throws {
        guard let key = item.queries[.attributeAccount] as? String else {
            throw StorageError.unknown
        }
        
        storage.removeValue(forKey: key)
    }
    
    // MARK: - Private
}

extension Collection where Element == any SIAttributes {
    subscript(_ key: SIKey) -> Any? {
        Dictionary<String, Any>(
            uniqueKeysWithValues: self
                .flatMap { $0.attributes }
        )[key.rawValue]
    }
}
