//
//  EnterCodeViewReduce.swift
//  
//
//  Created by JSilver on 2023/03/06.
//

import Feature
import CodeService

final class EnterCodeViewReduce: Reduce {
    enum Action {
        /// Load initial data.
        case load
        /// Try enter with code.
        case enter(code: String)
    }
    
    enum Mutation {
        /// Set total registered codes count state.
        case setTotalCodesCount(Int)
        /// Set remaining key count of state.
        case setRemainingKeyCount(Int, Date?)
        /// Set loading state.
        case setLoading(Bool)
        /// Send signal that code accepted.
        case acceptCode(Code)
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// Total registered codes count
        var totalCodesCount: Int?
        /// Remaining try key count
        var remainingKeyCount: Int
        /// Next code key generation Date
        var nextCodeKeyDate: Date?
        /// Max try key count
        let maxKeyCount: Int
        /// Loading
        var isLoading: Bool
        /// Signal that code accepted.
        @Revision
        var codeAccepted: Code?
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
            remainingKeyCount: codeService.codeKeyCount,
            nextCodeKeyDate: codeService.nextCodeKeyDate,
            maxKeyCount: 5,
            isLoading: false
        )
    }
    
    // MARK: - Lifecycle
    func start(with mutator: Mutator<Mutation, State>) async throws {
        let codeService = codeService
        
        Publishers.CombineLatest(
            codeService.codeKeyChanged,
            codeService.nextCodeKeyDateChanged
        )
            .sink { codeKeyCount, nextCodeKeyDate in
                mutator(.setRemainingKeyCount(
                    codeKeyCount,
                    nextCodeKeyDate
                ))
            }
            .store(in: &mutator.cancellableBag)
    }
    
    func mutate(state: State, action: Action) async throws {
        switch action {
        case .load:
            try await actionLoad(state)
            
        case let .enter(code):
            try await actionEnter(state, code: code)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setTotalCodesCount(count):
            state.totalCodesCount = count
            return state
            
        case let .setRemainingKeyCount(count, date):
            state.remainingKeyCount = count
            state.nextCodeKeyDate = date
            return state
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case let .acceptCode(code):
            state.codeAccepted = code
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionLoad(_ state: State) async throws {
        let count = (try? await codeService.totalRegisteredCodeCount()) ?? 0
        mutate(.setTotalCodesCount(count))
    }
    
    private func actionEnter(_ state: State, code: String) async throws {
        guard !state.isLoading else { return }
        
        mutate(.setLoading(true))
        
        do {
            let code = try await codeService.enterCode(code)
            
            mutate(.acceptCode(code))
            mutate(.setLoading(false))
        } catch {
            mutate(.setError(error))
            mutate(.setLoading(false))
        }
    }
}
