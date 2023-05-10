//
//  LaunchViewReduce.swift
//  
//
//  Created by JSilver on 2023/03/30.
//

import Feature
import AppService

final class LaunchViewReduce: Reduce {
    enum Action {
        /// Start launch process
        case launch
    }
    
    enum Mutation {
        /// Send signal that launch process completed.
        case completeLaunch(LaunchState)
        /// Send signal that error occurred.
        case setError(Error)
    }
    
    struct State {
        /// Signal that code accepted.
        @Revision
        var launchCompleted: LaunchState?
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
        
        self.initialState = State()
    }
    
    // MARK: - Lifecycle
    func mutate(state: State, action: Action) async throws {
        switch action {
        case .launch:
            try await actionLaunch(state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .completeLaunch(launchState):
            state.launchCompleted = launchState
            return state
            
        case let .setError(error):
            state.error = error
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionLaunch(_ state: State) async throws {
        do {
            async let config = appService.config()
            async let threshold: Void = Task.sleep(nanoseconds: 1_000_000_000)
            
            let (minimumVersion, _) = try await (Version(config.minimumVersion), threshold)
            
            guard versionAvailable(
                current: Env.Constant.version,
                minimum: minimumVersion
            ) else {
                mutate(.completeLaunch(.unsupportedVersion))
                return
            }
            
            mutate(.completeLaunch(.completed))
        } catch {
            mutate(.setError(error))
        }
    }
    
    private func versionAvailable(current: Version?, minimum: Version?) -> Bool {
        guard let current, let minimum, current >= minimum else { return false }
        return true
    }
}
