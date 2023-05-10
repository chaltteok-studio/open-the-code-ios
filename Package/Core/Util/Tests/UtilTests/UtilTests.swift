//
//  UtilTests.swift
//
//
//  Created by JSilver on 2023/03/06.
//

import XCTest
@testable import Util

final class UtilTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_positive_10000_should_convert_to_string_with_comma() {
        // Given
        let sut = 10000
        
        // When
        let result = sut.number
        
        // Then
        XCTAssertEqual(result, "10,000")
    }
    
    func test_that_negative_10000_should_convert_to_string_with_comma() {
        // Given
        let sut = -10000
        
        // When
        let result = sut.number
        
        // Then
        XCTAssertEqual(result, "-10,000")
    }
    
    func test_that_version_components_equal_when_initialize_from_version_string() {
        // Given
        
        // When
        
        // Then
        XCTAssertEqual(Version("1.1.1")?.major, 1)
        XCTAssertEqual(Version("1.1.1")?.minor, 1)
        XCTAssertEqual(Version("1.1.1")?.patch, 1)
        
        XCTAssertEqual(Version("1.1")?.major, 1)
        XCTAssertEqual(Version("1.1")?.minor, 1)
        XCTAssertEqual(Version("1.1")?.patch, 0)
        
        XCTAssertEqual(Version("1")?.major, 1)
        XCTAssertEqual(Version("1")?.minor, 0)
        XCTAssertEqual(Version("1")?.patch, 0)
        
        // Fail cases
        XCTAssertNil(Version("a.0.3"))
        XCTAssertNil(Version(""))
    }
    
    func test_that_return_true_when_version_compare_each_other() {
        // Given
        
        // When
        
        // Then
        XCTAssertTrue(Version("1.2.3")! < Version("2.0.0")!)
        XCTAssertTrue(Version("1.2.3")! < Version("1.3.0")!)
        XCTAssertTrue(Version("1.2.3")! < Version("1.2.4")!)
        XCTAssertTrue(Version("1.2.3")! == Version("1.2.3")!)
        XCTAssertTrue(Version("1.2.3")! > Version("1.2.2")!)
        XCTAssertTrue(Version("1.2.3")! > Version("1.1.9")!)
        XCTAssertTrue(Version("1.2.3")! > Version("1.1.4")!)
        XCTAssertTrue(Version("1.2.3")! > Version("1.1.11")!)
    }
    
    func test_that_version_to_string() {
        // Given
        
        // When
        
        // Then
        XCTAssertEqual(Version(major: 0, minor: 0, patch: 0).string(), "0.0.0")
        XCTAssertEqual(Version(major: 0, minor: 0, patch: 1).string(), "0.0.1")
        XCTAssertEqual(Version(major: 0, minor: 1, patch: 0).string(), "0.1.0")
        XCTAssertEqual(Version(major: 0, minor: 1, patch: 1).string(), "0.1.1")
        XCTAssertEqual(Version(major: 1, minor: 0, patch: 0).string(), "1.0.0")
        XCTAssertEqual(Version(major: 1, minor: 0, patch: 1).string(), "1.0.1")
        XCTAssertEqual(Version(major: 1, minor: 1, patch: 0).string(), "1.1.0")
        XCTAssertEqual(Version(major: 1, minor: 1, patch: 1).string(), "1.1.1")
        XCTAssertEqual(Version(major: 0, minor: 0, patch: 0).string(ignoresZero: true), "0")
        XCTAssertEqual(Version(major: 0, minor: 0, patch: 1).string(ignoresZero: true), "0.0.1")
        XCTAssertEqual(Version(major: 0, minor: 1, patch: 0).string(ignoresZero: true), "0.1")
        XCTAssertEqual(Version(major: 0, minor: 1, patch: 1).string(ignoresZero: true), "0.1.1")
        XCTAssertEqual(Version(major: 1, minor: 0, patch: 0).string(ignoresZero: true), "1")
        XCTAssertEqual(Version(major: 1, minor: 0, patch: 1).string(ignoresZero: true), "1.0.1")
        XCTAssertEqual(Version(major: 1, minor: 1, patch: 0).string(ignoresZero: true), "1.1")
        XCTAssertEqual(Version(major: 1, minor: 1, patch: 1).string(ignoresZero: true), "1.1.1")
    }
}
