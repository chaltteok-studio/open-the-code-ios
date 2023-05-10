//
//  CreateCodeViewReduce.swift
//
//
//  Created by JSilver on 2023/03/06.
//

import Feature
import CodeService

final class CreateCodeViewReduce: Reduce {
    enum Action {
        /// Create code with description
        case createCode(String, description: String)
    }
    
    enum Mutation {
        /// Set loading state.
        case setLoading(Bool)
        /// Send signal that code created.
        case created
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// Loading
        var isLoading: Bool
        /// Signal that code created.
        @Revision
        var codeCreated: Void?
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
            isLoading: false
        )
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        switch action {
        case let .createCode(code, description):
            try await actionCreateCode(state, code: code, description: description)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case .created:
            state.codeCreated = Void()
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionCreateCode(_ state: State, code: String, description: String) async throws {
        guard !state.isLoading else { return }
        
        mutate(.setLoading(true))
        
        do {
            try await codeService.createCode(code, content: description)
            
            mutate(.created)
            mutate(.setLoading(false))
        } catch {
            mutate(.setError(error))
            mutate(.setLoading(false))
        }
    }
}
