//
//  StoreTests.swift
//
//
//  Created by jsilver on 2022/02/03.
//

import XCTest
@testable import Store
import Storage

final class StoreTests: XCTestCase {
    // MARK: - Property
    private var storage: (any Storage)!
    
    // MARK: - Lifecycle
    override func setUp() {
        storage = MemoryStorage()
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_storage_save_the_value_after_value_is_assigned_via_store() {
        // Given
        @Store(storage, for: .init("a"))
        var value: String?
        
        // When
        XCTAssertNil(try? storage.read(forKey: "a"))
        
        value = "b"
        
        // Then
        XCTAssertEqual(try? storage.read(forKey: "a"), "b")
    }
    
    func test_that_store_value_equal_with_storage_value() {
        // Given
        @Store(storage, for: .init("a"))
        var value: String?
        
        // When
        try? storage.create("b", forKey: "a")
        
        // Then
        XCTAssertEqual(value, "b")
    }
    
    func test_that_storage_value_is_changed_when_assign_new_value() {
        // Given
        @Store(storage, for: .init("a"))
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
        @Store(storage, for: .init("a"))
        var value: String?
        value = "b"
        
        // When
        XCTAssertNotNil(try? storage.read(forKey: "a"))
        XCTAssertNoThrow(try _value.reset())
        
        // Then
        XCTAssertNil(try? storage.read(forKey: "a"))
    }
}
