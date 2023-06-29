//
//  CodeService.swift
//
//
//  Created by JSilver on 2023/03/26.
//

import Combine
import Service
import UserService

public protocol CodeServiceable {
    /// Currently remaining key count.
    var codeKeyCount: Int { get }
    /// Code key count changed.
    var codeKeyChanged: AnyPublisher<Int, Never> { get }
    /// Next code key recover date. if `nil` when code key already full.
    var nextCodeKeyDate: Date? { get }
    /// Next code key recover date changed.
    var nextCodeKeyDateChanged: AnyPublisher<Date?, Never> { get }
    /// The blocked codes.
    var blockedCodes: [String] { get }
    
    /// Create the code.
    func createCode(_ code: String, content: String) async throws
    /// Delete the code.
    func deleteCode(_ code: String) async throws
    /// Enter the code.
    func enterCode(_ code: String) async throws -> Code
    /// Block the code.
    func blockCode(_ code: String)
    /// Unblock the code.
    func unblockCode(_ code: String) throws
    /// Get total registered code count.
    func totalRegisteredCodeCount() async throws -> Int
    /// Get the codes that created by me.
    func myCodes() async throws -> [Code]
    /// Charge code keys.
    func chargeCodeKeys(amount: Int?)
    /// Check code key reovery during idle.
    func checkCodeKeysRecovery() async throws
}

public extension CodeServiceable {
    func chargeCodeKeys(amount: Int? = nil) {
        chargeCodeKeys(amount: amount)
    }
}

public class CodeService: CodeServiceable {
    // MARK: - Property
    private let dyson: Dyson
    private let userService: any UserServiceable
    
    private var codeKeyManager: CodeKeyManager
    
    public var codeKeyCount: Int { codeKeyManager.codeKeyCount }
    public var codeKeyChanged: AnyPublisher<Int, Never> { codeKeyManager.$codeKeyCount }
    
    public var nextCodeKeyDate: Date? {
        codeKeyManager.latestKeyRecoveryDate?
            .addingTimeInterval(CodeKeyManager.recoveryInterval)
    }
    public var nextCodeKeyDateChanged: AnyPublisher<Date?, Never> {
        codeKeyManager.$latestKeyRecoveryDate
            .map { $0?.addingTimeInterval(CodeKeyManager.recoveryInterval) }
            .eraseToAnyPublisher()
    }
    @Store
    public var blockedCodes: [String]
    
    private var totalRegisteredCodeCount: Int?
    
    // MARK: - Initializer
    public init(
        storage: any Storage,
        dyson: Dyson,
        userService: any UserServiceable
    ) {
        self.dyson = dyson
        self.userService = userService
        
        codeKeyManager = CodeKeyManager(storage: storage)
        
        // Set stored date.
        _blockedCodes = Store(storage, for: .blockedCodes, default: [])
    }
    
    // MARK: - Public
    public func createCode(_ code: String, content: String) async throws {
        try await dyson.data(CreateCodeSpec(.init(
            code: code,
            author: userService.userIdentifier,
            content: content
        )))
    }
    
    public func deleteCode(_ code: String) async throws {
        try await dyson.data(DeleteCodeSpec(.init(
            code: code
        )))
    }

    public func enterCode(_ code: String) async throws -> Code {
        guard codeKeyManager.hasKey else {
            throw CodeServiceError.keyNotEnough
        }
        
        guard !blockedCodes.contains(code) else {
            throw CodeServiceError.blockedKey
        }
        
        do {
            let result = try await dyson.data(GetCodeSpec(.init(
                code: code
            )))
            
            codeKeyManager.use(at: result.requestedAt)
            
            return Code(result)
        } catch let error as CSError {
            codeKeyManager.use(at: error.timestamp)
            throw error
        } catch {
            throw error
        }
    }
    
    public func blockCode(_ code: String) {
        blockedCodes.append(code)
    }
    
    public func unblockCode(_ code: String) throws {
        guard blockedCodes.contains(code) else { throw CodeServiceError.keyNotFound }
        blockedCodes.removeAll { $0 == code }
    }
    
    public func totalRegisteredCodeCount() async throws -> Int {
        if let totalRegisteredCodeCount {
            return totalRegisteredCodeCount
        }
        
        let result = try await dyson.data(GetCodesConfigInfoSpec(.init()))
        self.totalRegisteredCodeCount = result.count
        return result.count
    }

    public func myCodes() async throws -> [Code] {
        let result = try await dyson.data(GetCodesSpec(.init(
            author: userService.userIdentifier
        )))
        return result.codes.map { Code($0) }
    }
    
    public func chargeCodeKeys(amount: Int? = nil) {
        codeKeyManager.chargeCodeKeys(amount: amount)
    }
    
    public func checkCodeKeysRecovery() async throws {
        let target = GetTimeSpec(.init())
        let (_, response) = try await dyson.response(target)
        
        let dateString = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Date") ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        guard let date = formatter.date(from: dateString) else {
            throw CodeServiceError.unknown
        }
        
        codeKeyManager.checkRecovery(current: date)
    }
    
    // MARK: - Private
}
