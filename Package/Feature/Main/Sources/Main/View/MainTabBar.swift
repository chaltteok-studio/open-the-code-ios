//
//  MainTabBar.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import SwiftUI
import ChapssalKit
import TCUIKit

struct MainTabBar<Content: View>: View {
    // MARK: - View
    public var body: some View {
        let selectionInitialXOffset = (tabBarSize.width - tabSize.width) / 2
        let selectionXOffset = CGFloat(selection) * tabSize.width
        
        VStack {
            Spacer().layoutPriority(1)
            
            ZStack {
                // Background
                Capsule()
                    .foregroundColor(Color(uiColor: CR.Color.gray05))
                
                // Selected mark
                Circle()
                    .foregroundColor(Color(uiColor: CR.Color.gray02))
                    .padding(-4)
                    .offset(x: -selectionInitialXOffset)
                    .offset(x: selectionXOffset)
                    .animation(
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.75
                        ),
                        value: selection
                    )
                
                // Tab items
                HStack(spacing: 0) {
                    content()
                        .frame(
                            width: tabSize.width,
                            height: tabSize.height
                        )
                }
                    .layoutPriority(1)
                    .overlay(
                        GeometryReader { reader in
                            Color.clear
                                .onAppear {
                                    tabBarSize = reader.size
                                }
                        }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                selection = calculateSelectedTab(by: gesture.location.x)
                            }
                            .onEnded { gesture in
                                selection = calculateSelectedTab(by: gesture.location.x)
                            }
                    )
            }
            
            Spacer(minLength: 30)
        }
    }
    
    // MARK: - Property
    @Binding
    var selection: Int
    var content: () -> Content
    
    private let tabSize = CGSize(width: 48, height: 48)
    
    @State
    private var tabBarSize: CGSize = .zero
    
    // MARK: - Initializer
    public init(
        selection: Binding<Int>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func calculateSelectedTab(by currentOffset: CGFloat) -> Int {
        let maxTab = Int(tabBarSize.width / tabSize.width) - 1
        let currentTab = Int((currentOffset) / tabSize.width)
        
        return min(max(currentTab, 0), maxTab)
    }
}

#if DEBUG
struct MainTabBarPreview: View {
    var body: some View {
        MainTabBar(selection: $tab) {
            Image(systemName: "folder")
                .foregroundColor(tab == 0 ? .white : .black)
            Image(systemName: "paperplane")
                .foregroundColor(tab == 1 ? .white : .black)
            Image(systemName: "house.fill")
                .foregroundColor(tab == 2 ? .white : .black)
            Image(systemName: "person.fill")
                .foregroundColor(tab == 3 ? .white : .black)
            Image(systemName: "trash.fill")
                .foregroundColor(tab == 4 ? .white : .black)
        }
    }
    
    @State
    var tab: Int = 2
}

struct MainTabBarPreviews: PreviewProvider {
    static var previews: some View {
        MainTabBarPreview()
    }
}
#endif
