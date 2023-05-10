//
//  EmptyView.swift
//  
//
//  Created by JSilver on 2023/03/21.
//

import SwiftUI

public struct EmptyView: View {
    // MARK: - View
    public var body: some View {
        VStack(spacing: 12) {
            Image(uiImage: TR.Image.lock)
            Text(TR.Localization.emptyTitle)
                .font(Font(TR.Font.font(ofSize: 24)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
            Text(TR.Localization.emptyDescription)
                .font(Font(TR.Font.font(ofSize: 15)))
                .foregroundColor(Color(uiColor: CR.Color.gray04))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Public
    
    // MARK: - Private
}
