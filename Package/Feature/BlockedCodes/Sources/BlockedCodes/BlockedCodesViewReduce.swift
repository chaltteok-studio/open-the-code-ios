//
//  BlockedCodesReduce.swift
//
//
//  Created by JSilver on 2023/03/19.
//

import Feature
import CodeService

final class BlockedCodesViewReduce: Reduce {
    enum Action {
        /// Unblock the code.
        case unblockCode(String)
    }
    
    enum Mutation {
        /// Set blocked codes state.
        case setCodes([String])
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// The blocked codes
        var codes: [String]
        /// Error
        @Revision
        var error: Error?
    }
    
    // MARK: - Property
    private let codeService: any CodeServiceable
    
    var mutator: Mutator<Mutation, State>?
    var initialState: State
    
    // MARK: - Initializer
    init(codeService: any CodeServiceable) {
        self.codeService = codeService
        
        self.initialState = State(
            codes: codeService.blockedCodes
        )
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        switch action {
        case let .unblockCode(code):
            try await actionUnblockCode(state, code: code)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setCodes(codes):
            state.codes = codes
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionUnblockCode(_ state: State, code: String) async throws {
        do {
            try codeService.unblockCode(code)
        } catch {
            mutate(.setError(error))
        }
        
        mutate(.setCodes(codeService.blockedCodes))
    }
}
