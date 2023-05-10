//
//  BlockedCodesViewController.swift
//  
//
//  Created by JSilver on 2023/05/08.
//

import Feature
import CodeService

public protocol BlockedCodesControllerDelegate: AnyObject {
    func back()
}

public protocol BlockedCodesControllable: UIViewControllable {
    var delegate: (any BlockedCodesControllerDelegate)? { get set }
}

final class BlockedCodesViewController: ComposableController, BlockedCodesControllable {
    final private class Environment: ObservableObject {
        /// The code unblock tapped signal.
        @Published
        var unblockTapped: String?
    }

    // MARK: - Property
    private let router: any BlockedCodesRoutable
    weak var delegate: (any BlockedCodesControllerDelegate)?

    // MARK: - Initializer
    init(
        router: any BlockedCodesRoutable,
        reducer: Reducer<BlockedCodesViewReduce>
    ) {
        self.router = router
        
        let env = Environment()
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                codes: reducer.state.codes,
                onBackTap: {
                    self?.delegate?.back()
                },
                onUnblockTap: {
                    env.unblockTapped = $0
                }
            )
                // The code unblock confirm alert
                .alert(
                    env.$unblockTapped
                        .compactMap { $0 }
                ) { code, dismiss in
                    TCAlert(
                        TR.Localization.blockedCodesUnblockConfirmAlertTitle,
                        description: TR.Localization.blockedCodesUnblockConfirmAlertDescription
                    ) {
                        TCAlertAction(TR.Localization.errorAlertActionCancelTitle) {
                            dismiss(nil)
                        }
                        TCAlertAction(
                            TR.Localization.blockedCodesUnblockConfirmAlertActionUnblockTitle,
                            style: .destructive
                        ) {
                            dismiss {
                                reducer.action(.unblockCode(code))
                            }
                        }
                    }
                }
                // Error alert
                .error(
                    reducer.$state.map(\.$error)
                        .removeDuplicates()
                        .compactMap(\.value)
                )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
}

@ViewBuilder
private func Root(
    codes: [String],
    onBackTap: @escaping () -> Void,
    onUnblockTap: @escaping (String) -> Void
) -> some View {
    VStack(spacing: 0) {
        NavigationBar(
            title: TR.Localization.blockedCodesTitle,
            onBackTap: onBackTap
        )
        
        if !codes.isEmpty {
            Menus {
                MenuSection {
                    codes.map { code in
                        Menu(
                            code,
                            icon: Image(uiImage: CR.Icon.ic24Blind)
                        ) {
                            onUnblockTap(code)
                        }
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
    .background(
        Color(uiColor: CR.Color.gray01)
            .ignoresSafeArea()
    )
}

@ViewBuilder
private func NavigationBar(
    title: String?,
    onBackTap: @escaping () -> Void
) -> some View {
    CSUNavigationBar(title ?? "", alignment: .leading)
        .csuNavigationBar(\.style, .tcNavigationBar)
        .csuNavigationBar(
            \.leftAccessories,
             [
                CSUButton(image: Image(uiImage: CR.Icon.ic24Back)) {
                    onBackTap()
                }
                    .csuButton(\.style, .tcPlain)
                    .fixedSize()
             ]
        )
        .fixedSize(horizontal: false, vertical: true)
}

@ViewBuilder
private func EmptyView() -> some View {
    GeometryReader { reader in
        VStack {
            TCUIKit.EmptyView()
                .offset(y: -reader.size.height * 0.1)
        }
            .frame(
                width: reader.size.width,
                height: reader.size.height
            )
    }
}

#if DEBUG
import SwiftUI

class BlockedCodesMockRouter: BlockedCodesRoutable { }

struct BlockedCodes_Preview: View {
    var body: some View {
        BlockedCodesViewController(
            router: BlockedCodesMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init(codes: [])
            ))
        )
            .rootView
    }
}

struct BlockedCodes_Previews: PreviewProvider {
    static var previews: some View {
        BlockedCodes_Preview()
    }
}
#endif
