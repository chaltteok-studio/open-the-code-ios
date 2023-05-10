//
//  SecureStoreTests.swift
//  
//
//  Created by JSilver on 2023/02/16.
//

import XCTest
@testable import Store
import Storage

final class SecureStoreTests: XCTestCase {
    // MARK: - Property
    private var storage: (any SecureStorage)!
    
    // MARK: - Lifecycle
    override func setUp() {
        storage = MemorySecureStorage()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_storage_save_the_value_after_value_is_assigned_via_store() {
        // Given
        @SecureStore(storage, for: .init("a"))
        var value: String?
        
        // When
        XCTAssertNil(try? storage.read(forKey: "a"))
        
        value = "b"
        
        // Then
        XCTAssertEqual(try? storage.read(forKey: "a"), "b")
    }
    
    func test_that_store_value_equal_with_storage_value() {
        // Given
        @SecureStore(storage, for: .init("a"))
        var value: String?
        
        // When
        try? storage.create("b", forKey: "a")
        
        // Then
        XCTAssertEqual(value, "b")
    }
    
    func test_that_storage_value_is_changed_when_assign_new_value() {
        // Given
        @SecureStore(storage, for: .init("a"))
        var value: String?
        
        value = "b"
        
        // When
        XCTAssertNotNil(try? storage.read(forKey: "a"))
        
        value = "b2"
        
        // Then
        XCTAssertEqual(try? storage.read(forKey: "a"), "b2")
    }
    
    func test_that_stroage_value_is_removed_when_assign_nil() {
        // Given
        @SecureStore(storage, for: .init("a"))
        var value: String?
        
        value = "b"
        
        // When
        XCTAssertNotNil(try? storage.read(forKey: "a"))
        XCTAssertNoThrow(try _value.reset())
        
        // Then
        XCTAssertNil(try? storage.read(forKey: "a"))
    }
}
