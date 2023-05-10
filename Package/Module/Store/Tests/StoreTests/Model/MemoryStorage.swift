//
//  MemoryStorage.swift
//  
//
//  Created by JSilver on 2023/02/16.
//

import Foundation
import Storage

class MemoryStorage: Storage {
    // MARK: - Property
    var storage: [String: Data]
    
    // MARK: - Initializer
    init(storage: [String: any Codable] = [:]) {
        self.storage = storage.compactMapValues { try? JSONEncoder().encode($0) }
    }
    
    // MARK: - Public
    func create(_ data: Data, forKey key: String) throws {
        guard storage[key] == nil else { throw StorageError.alreadyExsit }
        storage[key] = data
    }
    
    func read(forKey key: String) throws -> Data {
        guard let data = storage[key] else { throw StorageError.notFound }
        return data
    }
    
    func update(_ data: Data, forKey key: String) throws {
        guard storage[key] != nil else { throw StorageError.notFound }
        storage[key] = data
    }
    
    func delete(forKey key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    // MARK: - Private
}
