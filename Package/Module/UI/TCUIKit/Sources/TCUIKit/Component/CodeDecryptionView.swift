//
//  CodeDecryptionView.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import SwiftUI
import Environment

public struct CodeDecryptionView: View {
    // MARK: - View
    public var body: some View {
        Text(text(text, count: count))
            .onReceive(timer) { _ in
                count += 1
                guard hit(0.1) else { return }
                
                // Set decryption text.
                text = Env.Constant.codeDecryptionTexts.randomElement() ?? ""
                // Reset count.
                count = 1
            }
    }
    
    // MARK: - Property
    @State
    private var text: String
    @State
    private var count: Int = 0
    
    private let timer = Timer.publish(every: 0.3, on: .main, in: .default)
        .autoconnect()
    
    // MARK: - Initializer
    public init() {
        self._text = .init(initialValue: Env.Constant.codeDecryptionTexts.randomElement() ?? "")
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func text(_ text: String, count: Int) -> String {
        text + (0..<count).map { _ in "." }.joined()
    }
    
    private func hit(_ percentage: Double) -> Bool {
        Double.random(in: 0...1) < percentage
    }
}
