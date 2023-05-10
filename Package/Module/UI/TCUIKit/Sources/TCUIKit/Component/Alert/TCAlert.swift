//
//  Alert.swift
//  
//
//  Created by JSilver on 2023/03/22.
//

import SwiftUI
import ChapssalKit
import JSToast

public struct TCAlertAction: View {
    public enum Style {
        case `default`
        case cancel
        case destructive
        
        var color: Color {
            switch self {
            case .default:
                return Color(uiColor: CR.Color.gray05)
                
            case .cancel:
                return Color(uiColor: CR.Color.gray04)
                
            case .destructive:
                return Color(uiColor: CR.Color.red01)
            }
        }
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(Font(TR.Font.font(ofSize: 18)))
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(style.color)
        }
    }
    
    let title: String
    let style: Style
    let action: () -> Void
    
    public init(
        _ title: String,
        style: Style = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public struct TCAlert: View {
    // MARK: - View
    public var body: some View {
        Backdrop {
            GeometryReader { reader in
                ZStack {
                    VStack(spacing: 0) {
                        Content()
                        ActionButton()
                    }
                        .frame(width: reader.size.width * 0.68)
                        .fixedSize()
                        .background(Color(uiColor: CR.Color.gray02))
                        .cornerRadius(8)
                        .offset(y: -reader.size.height * 0.05)
                }
                    .frame(
                        width: reader.size.width,
                        height: reader.size.height
                    )
            }
        }
    }
    
    @ViewBuilder
    private func Backdrop<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .background(Color(uiColor: CR.Color.gray01.withAlphaComponent(0.5)))
    }
    
    @ViewBuilder
    private func Content() -> some View {
        VStack(spacing: 14) {
            if let title = title {
                Text(title)
                    .font(Font(TR.Font.font(ofSize: 24)))
                    .lineLimit(1)
            }
            if let description = description {
                Text(description)
                    .font(Font(TR.Font.font(ofSize: 18)))
                    .multilineTextAlignment(.center)
            }
        }
            .foregroundColor(Color(uiColor: CR.Color.gray05))
            .padding(.vertical, 24)
            .padding(.horizontal, 14)
    }
    
    @ViewBuilder
    private func ActionButton() -> some View {
        ZStack {
            // Divider
            VStack {
                Rectangle().foregroundColor(Color(uiColor: CR.Color.gray05))
                    .frame(height: 1)
                
                Spacer()
            }
                .padding(.horizontal, 8)
            
            // Action Buttons
            HStack(spacing: 0) {
                Iterator(actions()) { action in
                    action
                }
            }
        }
    }
    
    // MARK: - Property
    private let title: String?
    private let description: String?
    private let actions: () -> [TCAlertAction]
    
    // MARK: - Initializer
    public init(
        _ title: String?,
        description: String?,
        @ArrayBuilder<TCAlertAction> actions: @escaping () -> [TCAlertAction]
    ) {
        self.title = title
        self.description = description
        self.actions = actions
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
