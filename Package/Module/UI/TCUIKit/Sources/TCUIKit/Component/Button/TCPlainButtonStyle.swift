//
//  TCPlainButtonStyle.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import SwiftUI
import ChapssalKit

public extension CSUButtonStyle where Self == TCPlainButtonStyle {
    static var tcPlain: Self { TCPlainButtonStyle() }
}

public struct TCPlainButtonStyle: CSUButtonStyle {
    private struct Content: View {
        // MARK: - View
        var body: some View {
            configuration.label
                .csuButton(
                    \.contentInsets,
                     config.$contentInsets(.init(.zero))
                )
                .csuButton(
                    \.backgroundColor,
                     config.$backgroundColor(.clear)
                )
                .csuButton(
                    \.pressedColor,
                     config.$pressedColor(nil)
                )
                .csuButton(\.animation, nil)
        }
        
        // MARK: - Property
        private let configuration: CSUButtonStyleConfiguration
        
        @Environment(\.csuButton)
        private var config: CSUButton.Configuration
        
        // MARK: - Initlalizer
        init(_ configuration: Configuration) {
            self.configuration = configuration
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    public func makeBody(_ configuration: Configuration) -> some View {
        Content(configuration)
    }
}
