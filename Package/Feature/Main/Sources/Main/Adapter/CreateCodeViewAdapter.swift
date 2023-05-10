//
//  CreateCodeViewAdapter.swift
//
//
//  Created by JSilver on 2023/03/12.
//

import SwiftUI
import RVB
import CreateCode

protocol CreateCodeControllable: ViewControllable {
    func onCodeCreate(_ action: @escaping () -> Void) -> Self
}

struct CreateCodeViewAdapter: UIViewControllerRepresentable, CreateCodeControllable {
    class Coordinator: CreateCodeDelegate {
        // MARK: - Property
        var onCodeCreate: (() -> Void)?
        
        // MARK: - Initializer
        init() { }
                
        // MARK: - Lifecycle
        func codeCreated() {
            onCodeCreate?()
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    // MARK: - Property
    private let builder: any CreateCodeBuildable
    private let parameter: CreateCodeParameter
    
    private var onCodeCreate: (() -> Void)?
    
    // MARK: - Initializer
    init(_ builder: any CreateCodeBuildable, with parameter: CreateCodeParameter) {
        self.builder = builder
        self.parameter = parameter
    }
    
    // MARK: - Lifecycle
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = builder.build(with: parameter)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.onCodeCreate = onCodeCreate
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Public
    func onCodeCreate(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.onCodeCreate = action
        return view
    }
    
    // MARK: - Private
}
