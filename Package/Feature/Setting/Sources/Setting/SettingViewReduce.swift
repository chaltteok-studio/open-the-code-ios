//
//  SettingViewReduce.swift
//
//
//  Created by JSilver on 2023/03/06.
//

import Feature
import CodeService

final class SettingViewReduce: Reduce {
    enum Action {
        case getReward
    }
    
    enum Mutation {
        case empty
    }
    
    struct State {
        
    }
    
    // MARK: - Property
    private let codeService: any CodeServiceable
    
    var mutator: Mutator<Mutation, State>?
    var initialState: State
    
    // MARK: - Initializer
    init(codeService: any CodeServiceable) {
        self.codeService = codeService
        
        self.initialState = State()
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        switch action {
        case .getReward:
            try await actionGetReward(state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        state
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionGetReward(_ state: State) async throws {
        codeService.chargeCodeKeys(amount: 1)
    }
}
