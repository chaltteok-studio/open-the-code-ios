//
//  LaunchViewController.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import Feature

public protocol LaunchControllerDelegate: AnyObject {
    func launch(_ launchController: LaunchControllable, didComplete state: LaunchState)
}

public protocol LaunchControllable: UIViewControllable, UINavigationControllerDelegate {
    var delegate: LaunchControllerDelegate? { get set }
}

final class LaunchViewController: ComposableController, LaunchControllable {
    final private class Environment: ObservableObject {
        
    }
    
    // MARK: - Property
    var router: LaunchRoutable?
    
    weak var delegate: LaunchControllerDelegate?

    // MARK: - Initializer
    init(
        router: LaunchRoutable,
        reducer: Reducer<LaunchViewReduce>
    ) {
        self.router = router
        
        let env = Environment()
        
        super.init(env, reducer)
        run { [weak self] in
            Root()
                .subscribe(
                    reducer.$state.map(\.$launchCompleted)
                        .removeDuplicates()
                        .compactMap(\.value)
                ) {
                    guard let self else { return }
                    
                    self.delegate?.launch(self, didComplete: $0)
                }
                .alert(
                    reducer.$state.map(\.$launchCompleted)
                        .removeDuplicates()
                        .compactMap(\.value)
                        .filter { $0 == .unsupportedVersion }
                ) { _, _ in
                    TCAlert(
                        TR.Localization.launchUnsupportedVersionAlertTitle,
                        description: TR.Localization.launchUnsupportedVersionAlertDescription
                    ) {
                        TCAlertAction(TR.Localization.launchUnsupportedVersionAlertCctionUpdateTitle) {
                            guard let url = URL(string: Env.URL.appStoreURL) else { return }
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .error(
                    reducer.$state.map(\.$error)
                        .removeDuplicates()
                        .compactMap(\.value)
                )
                .onAppear {
                    reducer.action(.launch)
                }
        }
    }
    
    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
}

extension LaunchViewController {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        LaunchAnimator()
    }
}

@ViewBuilder
private func Root() -> some View {
    ZStack {
        VStack(spacing: 0) {
            Image(uiImage: TR.Image.appIcon)
            Text(TR.Localization.appName.uppercased())
                .font(Font(TR.Font.font(ofSize: 48)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
        }
            .offset(y: -116)
        
        VStack {
            Spacer()
                .layoutPriority(1)
            
            Text(TR.Localization.copyright)
                .font(Font(TR.Font.font(ofSize: 16)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
            
            Spacer(minLength: 15)
        }
    }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(
            Color(uiColor: CR.Color.gray01)
                .ignoresSafeArea()
        )
}

#if DEBUG
import SwiftUI

private class LaunchMockRouter: LaunchRoutable { }

private struct Launch_Preview: View {
    var body: some View {
        LaunchViewController(
            router: LaunchMockRouter(),
            reducer: Reducer(proxy: .init(initialState: .init()))
        )
            .rootView
    }
}

struct Launch_Preivews: PreviewProvider {
    static var previews: some View {
        Launch_Preview()
    }
}
#endif
