//
//  MainViewController.swift
//  
//
//  Created by JSilver on 2023/03/12.
//

import Feature
import Setting

public protocol MainControllable: UIViewControllable {
    
}

final class MainViewController<Router: MainRoutable>: ComposableController, MainControllable {
    private final class Environment: ObservableObject {
        @Published
        var tab: Int = 0
    }
    
    // MARK: - Property
    let router: Router

    // MARK: - Initializer
    init(router: Router) {
        self.router = router
        
        let env = Environment()
        
        super.init(env)
        
        run { [weak self] in
            Root(
                enterCodeView: router.routeToEnterCode(with: .init()),
                createCodeView: router.routeToCreateCode(with: .init())
                    .onCodeCreate {
                        env.tab = 0
                    },
                tab: .object(env, path: \.tab),
                onSettingTap: {
                    self?.presentSetting(animated: true)
                }
            )
                .onChange(of: env.tab) { _ in
                    self?.view.endEditing(true)
                }
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public

    // MARK: - Private
    private func presentSetting(
        animated: Bool,
        force: Bool = true,
        completion: ((SettingControllable) -> Void)? = nil
    ) {
        let setting = router.routeToSetting(with: .init())
        
        setting.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(setting, animated: animated)
        }
    }
}

extension MainViewController: SettingControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

@ViewBuilder
private func Root(
    enterCodeView: some EnterCodeControllable,
    createCodeView: some View,
    tab: Binding<Int>,
    onSettingTap: @escaping () -> Void
) -> some View {
    GeometryReader { _ in
        VStack(spacing: 0) {
            NavigationBar(onSettingTap: onSettingTap)
            TabView(
                tab: tab,
                enterCodeView: enterCodeView,
                createCodeView: createCodeView
            )
        }
            .background(
                Color(uiColor: CR.Color.gray01)
                    .ignoresSafeArea()
            )
    }
        .ignoresSafeArea(.keyboard)
}

@ViewBuilder
private func NavigationBar(
    onSettingTap: @escaping () -> Void
) -> some View {
    CSUNavigationBar(TR.Localization.appName.uppercased(), alignment: .leading)
        .csuNavigationBar(\.style, .tcNavigationBar)
        .csuNavigationBar(
            \.rightAccessories,
             [
                CSUButton(image: Image(uiImage: CR.Icon.ic24Settings)) {
                    onSettingTap()
                }
                    .csuButton(\.style, .tcPlain)
                    .fixedSize()
             ]
        )
        .fixedSize(horizontal: false, vertical: true)
}

@ViewBuilder
private func TabView(
    tab: Binding<Int>,
    enterCodeView: some View,
    createCodeView: some View
) -> some View {
    ZStack {
        MainTabView(selection: tab) {
            enterCodeView
            createCodeView
        }
        MainTabBar(selection: tab) {
            Image(uiImage: CR.Icon.ic24Password)
                .foregroundColor(Color(uiColor: tab.wrappedValue == 0 ? CR.Color.gray05 : CR.Color.gray02))
            Image(uiImage: CR.Icon.ic24Add)
                .foregroundColor(Color(uiColor: tab.wrappedValue == 1 ? CR.Color.gray05 : CR.Color.gray02))
        }
    }
}

#if DEBUG
import EnterCode
import CreateCode
import Setting

class MainMockRouter: MainRoutable {
    struct EnterCode: EnterCodeControllable {
        var body: some View {
            ZStack {
                Rectangle().foregroundColor(.gray)
                
                Text("Enter Code")
            }
        }
    }
    
    struct CreateCode: CreateCodeControllable {
        var body: some View {
            ZStack {
                Rectangle().foregroundColor(.gray)
                
                Text("Create Code")
            }
        }
        
        func onCodeCreate(_ action: @escaping () -> Void) -> CreateCode {
            self
        }
    }
    
    class Setting: ComposableController, SettingControllable {
        weak var delegate: (any SettingControllerDelegate)?
    }
    
    func routeToEnterCode(with parameter: EnterCodeParameter) -> EnterCode {
        EnterCode()
    }
    
    func routeToCreateCode(with parameter: CreateCodeParameter) -> CreateCode {
        CreateCode()
    }
    
    func routeToSetting(with parameter: SettingParameter) -> any SettingControllable {
        Setting {
            Text("Setting")
        }
    }
}

struct Main_Preview: View {
    var body: some View {
        MainViewController(
            router: MainMockRouter()
        )
            .rootView
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main_Preview()
    }
}
#endif
