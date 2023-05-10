//
//  NoticeListReduce.swift
//
//
//  Created by JSilver on 2023/03/19.
//

import Feature
import AppService

final class NoticeListViewReduce: Reduce {
    enum Action {
        /// Load notices.
        case loadNotices
    }
    
    enum Mutation {
        /// Set notices state.
        case setNotices([Notice])
        /// Set loading state.
        case setLoading(Bool)
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// Notices
        var notices: [Notice]?
        /// Loading
        var isLoading: Bool
        /// Error
        @Revision
        var error: Error?
    }
    
    // MARK: - Property
    private let appService: any AppServiceable
    
    var mutator: Mutator<Mutation, State>?
    var initialState: State
    
    // MARK: - Initializer
    init(appService: any AppServiceable) {
        self.appService = appService
        
        self.initialState = State(
            isLoading: false
        )
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        switch action {
        case .loadNotices:
            try await actionLoadNotices(state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setNotices(notices):
            state.notices = notices
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
    private func actionLoadNotices(_ state: State) async throws {
        guard !state.isLoading else { return }
        
        mutate(.setLoading(true))
        
        do {
            let notices = try await appService.notices()
            
            mutate(.setNotices(notices))
            mutate(.setLoading(false))
        } catch {
            mutate(.setError(error))
            mutate(.setLoading(false))
        }
    }
}
