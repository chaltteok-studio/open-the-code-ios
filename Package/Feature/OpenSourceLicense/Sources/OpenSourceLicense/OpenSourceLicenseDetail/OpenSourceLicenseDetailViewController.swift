//
//  OpenSourceLicenseDetailViewController.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import Feature

protocol OpenSourceLicenseDetailControllerDelegate: AnyObject {
    func back()
}

protocol OpenSourceLicenseDetailControllable: UIViewControllable {
    var delegate: (any OpenSourceLicenseDetailControllerDelegate)? { get set }
}

final class OpenSourceLicenseDetailViewController: ComposableController, OpenSourceLicenseDetailControllable {
    final private class Environment: ObservableObject {
        
    }

    // MARK: - Property
    private let router: any OpenSourceLicenseDetailRoutable
    weak var delegate: (any OpenSourceLicenseDetailControllerDelegate)?

    // MARK: - Initializer
    init(
        router: any OpenSourceLicenseDetailRoutable,
        license: License
    ) {
        self.router = router
        
        let env = Environment()
        
        super.init(env)
        run { [weak self] in
            Root(
                license: license,
                onBackTap: {
                    self?.delegate?.back()
                }
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
    license: License,
    onBackTap: @escaping () -> Void
) -> some View {
    VStack(spacing: 0) {
        NavigationBar(
            title: license.name,
            onBackTap: onBackTap
        )
        
        ScrollView {
            Text(license.license)
                .padding(20)
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

#if DEBUG
class OpenSourceLicenseDetailMockRouter: OpenSourceLicenseDetailRoutable {
    
}

struct OpenSourceLicenseDetail_Preview: View {
    var body: some View {
        OpenSourceLicenseDetailViewController(
            router: OpenSourceLicenseDetailMockRouter(),
            license: .init(
                "The Code",
                license: "MIT"
            )
        )
            .rootView
    }
}

struct OpenSourceLicenseDetail_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceLicenseDetail_Preview()
    }
}
#endif
