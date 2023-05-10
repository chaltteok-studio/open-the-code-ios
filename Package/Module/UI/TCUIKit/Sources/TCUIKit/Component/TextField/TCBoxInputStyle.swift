//
//  TCBoxInputStyle.swift
//  
//
//  Created by JSilver on 2023/03/11.
//

import SwiftUI
import ChapssalKit

public extension CSUTextFieldStyle {
    static func tcBoxInput(state: any TCBoxInputState = TCBoxInputStyle.State.normal) -> Self where Self == TCBoxInputStyle { TCBoxInputStyle(state: state) }
}

public protocol TCBoxInputState {
    var tintColor: UIColor { get }
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var borderColor: UIColor { get }
}

public struct TCBoxInputStyle: CSUTextFieldStyle {
    public enum State: TCBoxInputState {
        case normal
        case error
        
        public var textColor: UIColor {
            tintColor
        }
        
        public var tintColor: UIColor {
            guard case .error = self else { return CR.Color.gray05 }
            return CR.Color.red01
        }
        
        public var backgroundColor: UIColor {
            CR.Color.gray02
        }
        
        public var borderColor: UIColor {
            guard case .error = self else { return backgroundColor }
            return CR.Color.red01
        }
    }
    
    private struct Content: View {
        // MARK: - View
        var body: some View {
            configuration.label
                .csuTextField(
                    \.tintColor,
                     config.$tintColor(state.tintColor)
                )
                .csuTextField(
                    \.textColor,
                     config.$textColor(state.textColor)
                )
                .csuTextField(
                    \.placeholderColor,
                     config.$placeholderColor(CR.Color.gray03)
                )
                .csuTextField(
                    \.font,
                     config.$font(TR.Font.font(ofSize: 18))
                )
                .csuTextField(
                    \.backgroundColor,
                     config.$backgroundColor(state.backgroundColor)
                )
                .csuTextField(
                    \.borderColor,
                     config.$borderColor(state.borderColor)
                )
        }
        
        // MARK: - Property
        private let configuration: CSUTextFieldStyleConfiguration
        private let state: any TCBoxInputState
        
        @Environment(\.isEnabled)
        private var isEnabled: Bool
        
        @Environment(\.csuTextField)
        private var config: CSUTextField.Configuration
        
        // MARK: - Initlalizer
        init(_ configuration: Configuration, state: any TCBoxInputState) {
            self.configuration = configuration
            self.state = state
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    public var state: any TCBoxInputState
    
    public init(state: any TCBoxInputState) {
        self.state = state
    }
    
    public func makeBody(_ configuration: Configuration) -> some View {
        Content(configuration, state: state)
    }
}

#if DEBUG
struct TCBoxInputStylePreview: View {
    var body: some View {
        ZStack {
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
            
            VStack {
                CSUTextField("Code", text: $text)
                    .csuTextField(\.style, .tcBoxInput())
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUTextField("Code", text: $text)
                    .csuTextField(\.style, .tcBoxInput(state: TCBoxInputStyle.State.error))
                    .fixedSize(horizontal: false, vertical: true)
            }
                .padding()
        }
    }
    
    @State
    private var text: String = ""
}

struct TCBoxInputStylePreviews: PreviewProvider {
    static var previews: some View {
        TCBoxInputStylePreview()
    }
}
#endif
