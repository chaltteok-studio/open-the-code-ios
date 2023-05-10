//
//  TCLineButtonStyle.swift
//  
//
//  Created by JSilver on 2023/03/11.
//

import SwiftUI
import ChapssalKit

public extension CSUButtonStyle where Self == TCLineButtonStyle {
    static var tcLine: Self { TCLineButtonStyle() }
}

public struct TCLineButtonStyle: CSUButtonStyle {
    private struct Content: View {
        // MARK: - View
        var body: some View {
            let textColor = Color(uiColor: isEnabled ? CR.Color.gray05 : CR.Color.gray03)
            let borderColor = textColor
            
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
                     config.$backgroundColor(.clear)
                )
                .csuButton(
                    \.animation,
                     config.$animation(isEnabled ? CR.Lottie.loadingWhite : CR.Lottie.loadingGray)
                )
                .csuButton(
                    \.cornerRadius,
                     config.$cornerRadius(8)
                )
                .csuButton(
                    \.borderColor,
                     config.$borderColor(borderColor)
                )
                .csuButton(
                    \.borderWidth,
                     config.$borderWidth(1)
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
struct TCLineButtonStylePreview: View {
    var body: some View {
        ZStack {
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
            
            VStack {
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcLine)
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcLine)
                    .csuButton(\.isLoading, true)
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcLine)
                    .disabled(true)
                    .fixedSize(horizontal: false, vertical: true)
                
                CSUButton(title: "THE CODE") { }
                    .csuButton(\.style, .tcLine)
                    .csuButton(\.isLoading, true)
                    .disabled(true)
                    .fixedSize(horizontal: false, vertical: true)
            }
                .padding()
        }
    }
}

struct TCLineButtonStylePreviews: PreviewProvider {
    static var previews: some View {
        TCLineButtonStylePreview()
    }
}
#endif
