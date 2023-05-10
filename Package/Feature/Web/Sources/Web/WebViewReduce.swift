//
//  WebReduce.swift
//  
//
//  Created by JSilver on 2023/03/24.
//

import Feature

final class WebViewReduce: Reduce {
    enum Action {
        case empty
    }
    
    enum Mutation {
        case empty
    }
    
    struct State {
        
    }
    
    // MARK: - Property
    var mutator: Mutator<Mutation, State>?
    var initialState: State
    
    // MARK: - Initializer
    init() {
        self.initialState = State()
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        state
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
