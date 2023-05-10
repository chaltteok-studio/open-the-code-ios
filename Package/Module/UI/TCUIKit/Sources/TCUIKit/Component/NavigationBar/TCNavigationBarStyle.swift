//
//  TCNavigationBarStyle.swift
//  
//
//  Created by JSilver on 2023/03/11.
//

import SwiftUI
import ChapssalKit

public extension CSUNavigationBarStyle where Self == TCNavigationBarStyle {
    static var tcNavigationBar: Self { TCNavigationBarStyle() }
}

public struct TCNavigationBarStyle: CSUNavigationBarStyle {
    private struct Content: View {
        // MARK: - View
        var body: some View {
            configuration.label
                .csuNavigationBar(
                    \.font,
                     config.$font(Font(TR.Font.font(ofSize: 20)))
                )
                .csuNavigationBar(
                    \.textColor,
                     config.$textColor(Color(uiColor: CR.Color.gray05))
                )
                .csuNavigationBar(
                    \.backgroundColor,
                     config.$backgroundColor(.clear)
                )
        }
        
        // MARK: - Property
        private let configuration: CSUNavigationBarStyleConfiguration
        
        @Environment(\.csuNavigationBar)
        private var config: CSUNavigationBar.Configuration
        
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
