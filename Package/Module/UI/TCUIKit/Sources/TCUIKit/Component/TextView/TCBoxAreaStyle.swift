//
//  TCBoxAreaStyle.swift
//  
//
//  Created by JSilver on 2023/03/16.
//

import SwiftUI
import ChapssalKit

public extension CSUTextViewStyle where Self == TCBoxAreaStyle {
    static var tcBoxArea: Self { TCBoxAreaStyle() }
}

public struct TCBoxAreaStyle: CSUTextViewStyle {
    private struct Content: View {
        // MARK: - View
        var body: some View {
            configuration.label
                .csuTextView(
                    \.tintColor,
                     config.$tintColor(CR.Color.gray05)
                )
                .csuTextView(
                    \.textColor,
                     config.$textColor(CR.Color.gray05)
                )
                .csuTextView(
                    \.placeholderColor,
                     config.$placeholderColor(CR.Color.gray03)
                )
                .csuTextView(
                    \.font,
                     config.$font(TR.Font.font(ofSize: 18))
                )
                .csuTextView(
                    \.backgroundColor,
                     config.$backgroundColor(CR.Color.gray02)
                )
                .csuTextView(
                    \.borderColor,
                     config.$borderColor(CR.Color.gray02)
                )
        }
        
        // MARK: - Property
        private let configuration: CSUTextViewStyleConfiguration
        
        @Environment(\.isEnabled)
        private var isEnabled: Bool
        
        @Environment(\.csuTextView)
        private var config: CSUTextView.Configuration
        
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

#if DEBUG
struct TCBoxAreaStyle_Preview: View {
    var body: some View {
        ZStack {
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
            
            VStack {
                CSUTextView("Code", text: $text)
                    .csuTextView(\.style, .tcBoxArea)
                    .frame(height: 140)
            }
                .padding()
        }
    }
    
    @State
    private var text: String = ""
}

struct TCBoxAreaStyle_Previews: PreviewProvider {
    static var previews: some View {
        TCBoxAreaStyle_Preview()
    }
}
#endif
