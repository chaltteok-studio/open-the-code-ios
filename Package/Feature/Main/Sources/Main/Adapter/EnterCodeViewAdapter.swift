//
//  EnterCodeViewAdapter.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import SwiftUI
import RVB
import EnterCode

protocol EnterCodeControllable: ViewControllable {
    
}

struct EnterCodeViewAdapter: UIViewControllerRepresentable, EnterCodeControllable {
    // MARK: - Property
    private let builder: any EnterCodeBuildable
    private let parameter: EnterCodeParameter
    
    private var onCodeCreate: (() -> Void)?
    
    // MARK: - Initializer
    init(_ builder: any EnterCodeBuildable, with parameter: EnterCodeParameter) {
        self.builder = builder
        self.parameter = parameter
    }
    
    // MARK: - Lifecycle
    func makeUIViewController(context: Context) -> UIViewController {
        builder.build(with: parameter)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
