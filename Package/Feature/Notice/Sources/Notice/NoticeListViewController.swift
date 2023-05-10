//
//  NoticeListViewController.swift
//  
//
//  Created by JSilver on 2023/03/20.
//

import Feature
import AppService
import Web

public protocol NoticeListControllerDelegate: AnyObject {
    func back()
}

public protocol NoticeListControllable: UIViewControllable {
    var delegate: (any NoticeListControllerDelegate)? { get set }
}

final class NoticeListViewController: ComposableController, NoticeListControllable {
    final private class Environment: ObservableObject {
        
    }

    // MARK: - Property
    private let router: any NoticeListRoutable
    weak var delegate: (any NoticeListControllerDelegate)?

    // MARK: - Initializer
    init(
        router: any NoticeListRoutable,
        reducer: Reducer<NoticeListViewReduce>
    ) {
        self.router = router
        
        let env = Environment()
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                notices: reducer.state.notices,
                isLoading: reducer.state.isLoading,
                onBackTap: {
                    self?.delegate?.back()
                },
                onNoticeTap: { notice in
                    guard let url = URL(string: notice.url) else { return }
                    self?.presentWeb(animated: true, url: url)
                }
            )
                .error(
                    reducer.$state.map(\.$error)
                        .removeDuplicates()
                        .compactMap(\.value)
                )
                .onAppear {
                    reducer.action(.loadNotices)
                }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
    private func presentWeb(
        animated: Bool,
        force: Bool = true,
        url: URL,
        completion: ((WebControllable) -> Void)? = nil
    ) {
        let web = router.routeToWeb(with: .init(
            url: url
        ))
        
        web.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(web, animated: animated)
        }
    }
}

extension NoticeListViewController: WebControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

@ViewBuilder
private func Root(
    notices: [Notice]?,
    isLoading: Bool,
    onBackTap: @escaping () -> Void,
    onNoticeTap: @escaping (Notice) -> Void
) -> some View {
    VStack(spacing: 0) {
        NavigationBar(
            title: TR.Localization.noticeTitle,
            onBackTap: onBackTap
        )
        
        if !isLoading {
            if let notices, !notices.isEmpty {
                Menus {
                    MenuSection {
                        notices.map { notice in
                            Menu(
                                notice.title,
                                description: notice.createdAt.formatted("yy.MM.dd")
                            ) {
                                onNoticeTap(notice)
                            }
                        }
                    }
                }
            } else {
                EmptyView()
            }
        } else {
            LoadingView()
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
private func LoadingView() -> some View {
    VStack {
        HStack {
            CodeDecryptionView()
                .font(Font(TR.Font.font(ofSize: 18)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
            Spacer()
        }
            .padding(20)
        
        Spacer()
    }
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
class NoticeListMockRouter: NoticeListRoutable {
    final private class Web: ComposableController, WebControllable {
        weak var delegate: (WebControllerDelegate)?
    }
    
    func routeToWeb(with parameter: WebParameter) -> WebControllable {
        Web {
            Text("Web")
        }
    }
}

struct NoticeList_Preview: View {
    var body: some View {
        NoticeListViewController(
            router: NoticeListMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init(
                    isLoading: false
                )
            ))
        )
            .rootView
    }
}

struct NoticeList_Previews: PreviewProvider {
    static var previews: some View {
        NoticeList_Preview()
    }
}
#endif
