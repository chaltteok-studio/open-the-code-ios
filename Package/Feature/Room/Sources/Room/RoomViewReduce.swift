//
//  RoomViewReduce.swift
//
//
//  Created by JSilver on 2023/03/06.
//

import Feature
import UserService
import CodeService

final class RoomViewReduce: Reduce {
    enum Action {
        /// Delete the code
        case deleteCode
        /// Block the code
        case blockCode
    }
    
    enum Mutation {
        /// Set loading state.
        case setLoading(Bool)
        /// Send signal that code deleted.
        case deleteCode
        /// Send signal that code blocked.
        case blockCode
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// Code
        let code: String
        /// Code description
        var description: String
        /// Is the code own
        var isOwner: Bool
        /// Loading
        var isLoading: Bool
        /// Signal that code deleted.
        @Revision
        var codeDeleted: Void?
        /// Signal that coed blocked.
        @Revision
        var codeBlocked: Void?
        /// Error
        @Revision
        var error: Error?
    }
    
    // MARK: - Property
    private let codeService: any CodeServiceable
    
    var mutator: Mutator<Mutation, State>?
    var initialState: State
    
    // MARK: - Initializer
    init(
        userService: any UserServiceable,
        codeService: any CodeServiceable,
        code: Code
    ) {
        self.codeService = codeService
        
        self.initialState = State(
            code: code.code,
            description: code.content,
            isOwner: userService.userIdentifier == code.author,
            isLoading: false
        )
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        switch action {
        case .deleteCode:
            try await actionDeleteCode(state)
            
        case .blockCode:
            try await actionBlockCode(state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case .deleteCode:
            state.codeDeleted = Void()
            return state
            
        case .blockCode:
            state.codeBlocked = Void()
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionDeleteCode(_ state: State) async throws {
        guard !state.isLoading else { return }
        
        mutate(.setLoading(true))
        
        do {
            try await codeService.deleteCode(state.code)
            
            mutate(.deleteCode)
            mutate(.setLoading(false))
        } catch {
            mutate(.setError(error))
            mutate(.setLoading(false))
        }
    }
    
    private func actionBlockCode(_ state: State) async throws {
        codeService.blockCode(state.code)
        
        mutate(.blockCode)
    }
}
