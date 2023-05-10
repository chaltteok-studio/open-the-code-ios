//
//  Store.swift
//
//
//  Created by jsilver on 2022/02/06.
//

import Foundation
import Combine
import Storage
import Environment

@propertyWrapper
public struct Store<Value: Codable> {
    // MARK: - Property
    private let queue = DispatchQueue(label: "sample.chaltteok-studio.store")
    
    private let storage: any Storage
    private let key: StoreKey
    private let defaultValue: Value
    
    public var wrappedValue: Value {
        get {
            (try? storage.read(forKey: key.rawValue)) ?? defaultValue
        }
        set {
            let copy = self
            
            queue.sync {
                do {
                    if let _ = try? copy.storage.read(forKey: copy.key.rawValue) {
                        try copy.storage.update(newValue, forKey: copy.key.rawValue)
                    } else {
                        try copy.storage.create(newValue, forKey: copy.key.rawValue)
                    }
                    
                    copy.subject.send(newValue)
                } catch {
                    // Do nothing.
                }
            }
        }
    }
    
    private let subject: CurrentValueSubject<Value, Never>
    public var projectedValue: AnyPublisher<Value, Never> {
        subject.share()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    public init(_ storage: any Storage, for key: StoreKey, default value: Value) {
        self.storage = storage
        self.key = key
        self.defaultValue = value
        
        self.subject = CurrentValueSubject((try? storage.read(forKey: key.rawValue)) ?? value)
    }
    
    // MARK: - Public
    public func reset() throws {
        try storage.delete(forKey: key.rawValue)
    }
    
    // MARK: - Private
}

public extension Store where Value: ExpressibleByNilLiteral {
    init(_ storage: any Storage, for key: StoreKey) {
        self.init(storage, for: key, default: .init(nilLiteral: Void()))
    }
}
