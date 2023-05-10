//
//  TCFillButtonStyle.swift
//
//
//  Created by JSilver on 2023/03/11.
//

import SwiftUI
import ChapssalKit

public extension CSUButtonStyle where Self == TCFillButtonStyle {
    static var tcFill: Self { TCFillButtonStyle() }
}

public struct TCFillButtonStyle: CSUButtonStyle {
    private struct Content: View {
        // MARK: - View
        var body: some View {
            let textColor = Color(uiColor: isEnabled ? CR.Color.gray01 : CR.Color.gray04)
            let backgroundColor = Color(uiColor: isEnabled ? CR.Color.gray05 : CR.Color.gray03)
            
            configuration.label
                .csuButton(
                    \.textColor,
                     config.$textColor(textColor)
                )
                .csuButton(
                    \.font,
                     config.$font(Font(TR.Font.font(ofSize: 20)))
                )
                .csuButton(
                    \.backgroundColor,
                     config.$backgroundColor(backgroundColor)
                )
                .csuButton(
                    \.animation,
                     config.$animation(isEnabled ? CR.Lottie.loadingGray : CR.Lottie.loadingWhite)
                )
                .csuButton(
                    \.cornerRadius,
                     config.$cornerRadius(8)
                )
                .disabled(config.isLoading)
        }
        
        // MARK: - Property
        private let configuration: CSUButtonStyleConfiguration
        
        @Environment(\.isEnabled)
        private var isEnabled: Bool
        
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

#if DEBUG
struct TCFillButtonStyle_Preview: View {
    var body: some View {
        ZStack {
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
            
            VStack {
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcFill)
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcFill)
                    .csuButton(\.isLoading, true)
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcFill)
                    .disabled(true)
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcFill)
                    .csuButton(\.isLoading, true)
                    .disabled(true)
                    .fixedSize(horizontal: false, vertical: true)
            }
                .padding()
        }
    }
}

struct TCFillButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        TCFillButtonStyle_Preview()
    }
}
#endif
