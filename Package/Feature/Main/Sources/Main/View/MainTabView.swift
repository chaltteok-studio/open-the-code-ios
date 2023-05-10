//
//  MainTabView.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import SwiftUI
import ChapssalKit

struct MainTabView<
    Content: View
>: View {
    // MARK: - View
    public var body: some View {
        GeometryReader { reader in
            let tabSize = reader.size
            
            let maxXOffset = max(contentSize.width - tabSize.width, 0)
            let contentXOffset = min(max(contentOffset.x - translation.width, 0), maxXOffset)
            
            // Tab content
            HStack(spacing: 0) {
                content()
                    .frame(
                        width: tabSize.width,
                        height: tabSize.height
                    )
            }
                .contentShape(Rectangle())
                .overlay(
                    GeometryReader { reader in
                        Color.clear
                            .onAppear {
                                self.contentSize = reader.size
                            }
                    }
                )
                .offset(x: -contentXOffset)
                .animation(
                    .spring(
                        response: 0.3,
                        dampingFraction: 0.75
                    ),
                    value: contentXOffset
                )
            
                .gesture(
                    DragGesture()
                        .updating($translation) { gesture, state, _ in
                            state = gesture.translation
                        }
                        .onChanged { _ in
                            // Calculate current tab.
                            selection = Int((contentXOffset / tabSize.width).rounded())
                        }
                        .onEnded { gesture in
                            // Calculate current tab.
                            let velocity = gesture.predictedEndLocation.x - gesture.location.x
                            if abs(velocity) > 200 {
                                let maxTab = Int(contentSize.width / tabSize.width) - 1
                                let additionalTab = velocity < 0 ? 1 : -1
                                
                                selection = min(max(selection + additionalTab, 0), maxTab)
                            } else {
                                selection = Int((contentXOffset / tabSize.width).rounded())
                            }
                            
                            // Set base content offset.
                            contentOffset.x = CGFloat(selection) * tabSize.width
                        }
                )
                .onChange(of: selection) {
                    guard translation == .zero else { return }
                    // Set base content offset when selection changed.
                    contentOffset.x = CGFloat($0) * tabSize.width
                }
        }
    }
    
    // MARK: - Property
    @Binding
    var selection: Int
    var content: () -> Content
    
    @State
    private var contentSize: CGSize = .zero
    
    @State
    private var contentOffset: CGPoint = .zero
    @GestureState
    private var translation: CGSize = .zero
    
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
}

#if DEBUG
struct MainTabViewPreview: View {
    var body: some View {
        MainTabView(
            selection: $selection
        ) {
            Color.red
            Color.blue
            Color.green
        }
    }
    
    @State
    var selection: Int = 0
}

struct MainTabViewPreviews: PreviewProvider {
    static var previews: some View {
        MainTabViewPreview()
    }
}
#endif
