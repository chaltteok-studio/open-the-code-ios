//
//  OpenSourceLicenseListViewController.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import Feature

public protocol OpenSourceLicenseListControllerDelegate: AnyObject {
    func back()
}

public protocol OpenSourceLicenseListControllable: UIViewControllable {
    var delegate: (any OpenSourceLicenseListControllerDelegate)? { get set }
}

final class OpenSourceLicenseListViewController: ComposableController, OpenSourceLicenseListControllable {
    final private class Environment: ObservableObject {
        
    }

    // MARK: - Property
    private let router: any OpenSourceLicenseListRoutable
    weak var delegate: (any OpenSourceLicenseListControllerDelegate)?

    // MARK: - Initializer
    init(
        router: any OpenSourceLicenseListRoutable,
        reducer: Reducer<OpenSourceLicenseListViewReduce>
    ) {
        self.router = router
        
        let env = Environment()
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                licenses: reducer.state.licenses,
                onBackTap: {
                    self?.delegate?.back()
                },
                onLicenseTap: { license in
                    self?.presentOpenSourceLicenseDetail(
                        animated: true,
                        license: license
                    )
                }
            )
                .onAppear {
                    reducer.action(.loadLicense)
                }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
    private func presentOpenSourceLicenseDetail(
        animated: Bool,
        force: Bool = true,
        license: License,
        completion: ((OpenSourceLicenseDetailControllable) -> Void)? = nil
    ) {
        let openSourceLicenseDetail = router.routeToOpenSourceLicenseDetail(with: .init(
            license: license
        ))
        
        openSourceLicenseDetail.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(openSourceLicenseDetail, animated: animated)
        }
    }
}

extension OpenSourceLicenseListViewController: OpenSourceLicenseDetailControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

@ViewBuilder
private func Root(
    licenses: [License]?,
    onBackTap: @escaping () -> Void,
    onLicenseTap: @escaping (License) -> Void
) -> some View {
    VStack(spacing: 0) {
        NavigationBar(
            title: TR.Localization.openSourceLicenseTitle,
            onBackTap: onBackTap
        )
        
        if let licenses {
            Menus {
                MenuSection {
                    licenses.map { license in
                        Menu(license.name) {
                            onLicenseTap(license)
                        }
                    }
                }
            }
        } else {
            Spacer()
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
class OpenSourceLicenseListMockRouter: OpenSourceLicenseListRoutable {
    class OpenSourceLicenseDetail: ComposableController, OpenSourceLicenseDetailControllable {
        weak var delegate: (any OpenSourceLicenseDetailControllerDelegate)?
    }
    
    func routeToOpenSourceLicenseDetail(with parameter: OpenSourceLicenseDetailParameter) -> OpenSourceLicenseDetailControllable {
        OpenSourceLicenseDetail {
            Text("OpenSourceLicenseDetailb")
        }
    }
}

struct OpenSourceLicenseList_Preview: View {
    var body: some View {
        OpenSourceLicenseListViewController(
            router: OpenSourceLicenseListMockRouter(),
            reducer: .init(proxy: .init(initialState: .init()))
        )
            .rootView
    }
}

struct OpenSourceLicenseList_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceLicenseList_Preview()
    }
}
#endif
