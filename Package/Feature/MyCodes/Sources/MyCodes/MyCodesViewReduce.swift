//
//  MyCodesReduce.swift
//
//
//  Created by JSilver on 2023/03/19.
//

import Feature
import CodeService

final class MyCodesViewReduce: Reduce {
    enum Action {
        /// Load my codes.
        case load
    }
    
    enum Mutation {
        /// Set my codes state.
        case setCodes([Code])
        /// Set loading state.
        case setLoading(Bool)
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// Codes
        var codes: [Code]?
        /// Loading
        var isLoading: Bool
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
        case .load:
            try await actionLoadCodes(state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setCodes(codes):
            state.codes = codes
            return state
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionLoadCodes(_ state: State) async throws {
        guard !state.isLoading else { return }
        
        mutate(.setLoading(true))
        
        do {
            let codes = try await codeService.myCodes()
            
            mutate(.setCodes(codes))
            mutate(.setLoading(false))
        } catch {
            mutate(.setError(error))
            mutate(.setLoading(false))
        }
    }
}
