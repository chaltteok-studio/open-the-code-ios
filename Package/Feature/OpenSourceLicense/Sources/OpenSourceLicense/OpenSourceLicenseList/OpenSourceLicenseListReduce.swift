//
//  OpenSourceLicenseListReduce.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import Feature

final class OpenSourceLicenseListViewReduce: Reduce {
    enum Action {
        /// Load open source licenses.
        case loadLicense
    }
    
    enum Mutation {
        /// Set open source licenses state.
        case setLicenses([License])
    }
    
    struct State {
        /// Open source licenses.
        var licenses: [License]?
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
        switch action {
        case .loadLicense:
            try await actionLoadLicense(state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setLicenses(licenses):
            state.licenses = licenses
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func actionLoadLicense(_ state: State) async throws {
        guard let licenseURLs = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "License") else { return }
        
        let licenses = licenseURLs.compactMap { url -> License? in
            guard let data = try? Data(contentsOf: url),
                let license = String(data: data, encoding: .utf8)
            else { return nil }
            
            return License(url.lastPathComponent, license: license)
        }
            .sorted { $0.name < $1.name }
        
        mutate(.setLicenses(licenses))
    }
}
