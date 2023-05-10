//
//  APITests.swift
//
//
//  Created by JSilver on 2023/03/06.
//

import XCTest
import Logger
import Network
@testable import API
import Environment

final class APITests: XCTestCase {
    // MARK: - Property
    private let networkProvider = URLNetworkProvider(
        interceptors: [
            LogInterceptor()
        ]
    )
    
    // MARK: - Lifecycle
    override class func setUp() {
        #if DEBUG
        Env.config = .develop
        #else
        Env.config = .live
        #endif
        
        Logger.configure([ConsolePrinter()])
    }
    
    // MARK: - Test
    func test_that_request_with_get_notices_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCStaticNetworkResponser.self)
        let target = NoticesTarget(.init())
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_get_time_target() async throws {
        // Given
        let provider = networkProvider
        let target = GetTimeTarget(.init())
        
        do {
            // When
            let (_, response) = try await provider.request(target)
            
            let dateString = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Date") ?? ""
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "GMT")
            
            let date = formatter.date(from: dateString)
            
            // Then
            XCTAssertNotNil(date)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_get_config_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCStaticNetworkResponser.self)
        let target = GetConfigTarget(.init())
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_get_code_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCNetworkResponser.self)
        let target = GetCodeTarget(.init(code: "test"))
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_get_codes_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCNetworkResponser.self)
        let target = GetCodesTarget(.init(author: "-1"))
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_create_code_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCNetworkResponser.self)
        let target = CreateCodeTarget(.init(
            code: "test",
            author: "-1",
            content: "Testing..."
        ))
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_delete_code_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCNetworkResponser.self)
        let target = DeleteCodeTarget(.init(
            code: "test"
        ))
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_that_request_with_get_codes_config_info_target() async throws {
        // Given
        let responser = networkProvider
            .responser(TCNetworkResponser.self)
        let target = GetCodesConfigInfoTarget(.init())
        
        do {
            // When
            _ = try await responser.request(target)
            
            // Then
        } catch {
            XCTFail("\(error)")
        }
    }
}
