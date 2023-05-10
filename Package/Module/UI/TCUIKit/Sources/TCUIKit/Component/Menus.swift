//
//  Menus.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import SwiftUI
import ChapssalKit

public protocol MenuContent: View { }

public struct Menus: View {
    // MARK: - View
    public var body: some View {
        ScrollView {
            VStack(spacing: interSectionSpacing) {
                let content = content().map { AnyView($0) }
                ForEach(0..<content.count, id: \.self) {
                    content[$0]
                }
            }
            .padding(contentInsets)
        }
    }
    
    // MARK: - Property
    public let title: String?
    private let interSectionSpacing: CGFloat
    private let contentInsets: EdgeInsets
    
    private let content: () -> [any MenuContent]
    
    // MARK: - Initializer
    public init(
        _ title: String? = nil,
        interSectionSpacing: CGFloat = 48,
        contentInsets: EdgeInsets = .init(
            top: 24,
            leading: 0,
            bottom: 24,
            trailing: 0
        ),
        @ArrayBuilder<any MenuContent> content: @escaping () -> [any MenuContent]
    ) {
        self.title = title
        self.interSectionSpacing = interSectionSpacing
        self.contentInsets = contentInsets
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public struct MenuSection: MenuContent {
    // MARK: - View
    public var body: some View {
        VStack(spacing: 2) {
            if let title {
                HStack {
                    Text(title)
                        .font(Font(TR.Font.font(ofSize: 16)))
                        .padding(.leading, 24)
                    Spacer()
                }
            }
            
            VStack(spacing: 0) {
                let content = content().map { AnyView($0) }
                ForEach(0..<content.count, id: \.self) {
                    content[$0]
                }
            }
        }
        .foregroundColor(Color(uiColor: CR.Color.gray05))
    }
    
    // MARK: - Property
    private let title: String?
    
    private let content: () -> [any MenuContent]
    
    // MARK: - Initializer
    public init(
        _ title: String? = nil,
        @ArrayBuilder<any MenuContent> content: @escaping () -> [any MenuContent]
    ) {
        self.title = title
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public struct Menu: MenuContent {
    // MARK: - View
    public var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                Group {
                    HStack {
                        Text(title)
                            .font(Font(TR.Font.font(ofSize: 20)))
                        
                        Spacer()
                        
                        if let description {
                            Text(description)
                                .foregroundColor(Color(uiColor: CR.Color.gray04))
                                .font(Font(TR.Font.font(ofSize: 20)))
                        }
                        
                        if let icon {
                            icon
                        }
                    }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                    
                    VStack {
                        Spacer()
                        Rectangle().frame(height: 1)
                    }
                        .padding(.leading, 24)
                }
                
                if isHighlight && action != nil {
                    Color(uiColor: CR.Color.white.withAlphaComponent(0.3))
                }
            }
                .foregroundColor(Color(uiColor: CR.Color.gray05))
                .contentShape(Rectangle())
        }
            .buttonStyle(.highlight($isHighlight))
    }
    
    // MARK: - Property
    private let title: String
    private let description: String?
    private let icon: Image?
    private let action: (() -> Void)?
    
    @State
    private var isHighlight: Bool = false
    
    // MARK: - Initializer
    public init(
        _ title: String,
        description: String? = nil,
        icon: Image? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.action = action
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

#if DEBUG
struct Menu_Preview: View {
    var body: some View {
        Menus {
            MenuSection("Section Title") {
                Menu("Title") { }
                Menu("Title", description: "Description") { }
                Menu("Title", description: "Description", icon: Image(uiImage: CR.Icon.ic24Blind)) { }
                Menu("Title", icon: Image(uiImage: CR.Icon.ic24Blind)) { }
            }
            
            MenuSection("Section Title") {
                Menu("Title") { }
                Menu("Title", description: "Description") { }
                Menu("Title", description: "Description", icon: Image(uiImage: CR.Icon.ic24Blind)) { }
                Menu("Title", icon: Image(uiImage: CR.Icon.ic24Blind)) { }
            }
        }
            .background(
                Color(uiColor: CR.Color.gray01)
                    .ignoresSafeArea()
            )
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu_Preview()
    }
}
#endif
