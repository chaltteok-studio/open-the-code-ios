//
//  SettingViewController.swift
//  
//
//  Created by JSilver on 2023/03/19.
//

import GoogleMobileAds
import Feature
import Notice
import MyCodes
import BlockedCodes
import OpenSourceLicense

public protocol SettingControllerDelegate: AnyObject {
    func back()
}

public protocol SettingControllable: UIViewControllable {
    var delegate: (any SettingControllerDelegate)? { get set }
}

final class SettingViewController: ComposableController, SettingControllable {
    final private class Environment: ObservableObject {
        @Published
        var isCopiedDeveloperToastShow: Bool = false
    }
    
    // MARK: - Property
    private let router: any SettingRoutable
    private let reducer: Reducer<SettingViewReduce>
    weak var delegate: (any SettingControllerDelegate)?
    
    private var rewardedAD: GADRewardedAd?

    // MARK: - Initializer
    init(
        router: any SettingRoutable,
        reducer: Reducer<SettingViewReduce>,
        menus: Menus?
    ) {
        self.router = router
        self.reducer = reducer
        
        let env = Environment()
        
        super.init(env)
        run { [weak self] in
            Root(
                menus: menus ?? .setting {
                    self?.handle(
                        menu: $0,
                        isCopiedDeveloperToastShow: .object(env, path: \.isCopiedDeveloperToastShow)
                    )
                },
                onBackTap: {
                    self?.delegate?.back()
                }
            )
            .toast(
                .object(env, path: \.isCopiedDeveloperToastShow),
                layouts: [
                    .inside(.top, offset: 24),
                    .center(.x)
                ],
                showAnimation: .slideIn(
                    duration: 0.2,
                    direction: .down
                )
            ) {
                Text(TR.Localization.settingToastCopiedDeveloper)
                    .foregroundColor(Color(uiColor: CR.Color.gray05))
                    .font(Font(TR.Font.font(ofSize: 18)))
                    .padding()
                    .background(
                        Capsule().foregroundColor(Color(uiColor: CR.Color.gray03))
                    )
            }
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    // MARK: - Public

    // MARK: - Private
    private func handle(menu: MenuType, isCopiedDeveloperToastShow: Binding<Bool>) {
        switch menu {
        case .notice:
            presentNoticeList(animated: true)
            
        case .developer:
            UIPasteboard.general.string = Env.Constant.csEmail
            isCopiedDeveloperToastShow.wrappedValue = true
            
        case .openSourceLicense:
            presentOpenSourceLicense(animated: true)
            
        case .myCode:
            presentMyCodes(animated: true)
            
        case .blockedCode:
            presentBlockedCodes(animated: true)
            
        case .getKey:
            presentRewardAD()
        }
    }
    
    private func presentSetting(
        animated: Bool,
        force: Bool = true,
        menus: Menus,
        completion: ((SettingControllable) -> Void)? = nil
    ) {
        let setting = router.routeToSetting(with: .init(
            menus: menus
        ))
        
        setting.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(setting, animated: animated)
        }
    }
    
    private func presentNoticeList(
        animated: Bool,
        force: Bool = true,
        completion: ((NoticeListControllable) -> Void)? = nil
    ) {
        let noticeList = router.routeToNoticeList(with: .init())
        
        noticeList.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(noticeList, animated: animated)
        }
    }
    
    private func presentMyCodes(
        animated: Bool,
        force: Bool = true,
        completion: ((MyCodesControllable) -> Void)? = nil
    ) {
        let myCodes = router.routeToMyCodes(with: .init())
        
        myCodes.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(myCodes, animated: animated)
        }
    }
    
    private func presentBlockedCodes(
        animated: Bool,
        force: Bool = true,
        completion: ((BlockedCodesControllable) -> Void)? = nil
    ) {
        let blockedCodes = router.routeToBlockedCodes(with: .init())
        
        blockedCodes.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(blockedCodes, animated: animated)
        }
    }
    
    private func presentOpenSourceLicense(
        animated: Bool,
        force: Bool = true,
        completion: ((OpenSourceLicenseListControllable) -> Void)? = nil
    ) {
        let openSourceLicenseList = router.routeToOpenSourceLicenseList(with: .init())
        
        openSourceLicenseList.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(openSourceLicenseList, animated: animated)
        }
    }
    
    private func presentRewardAD() {
        let request = GADRequest()
        
        GADRewardedAd.load(
            withAdUnitID: AdMobKey.codeKeyReward.rawValue,
            request: request
        ) { [weak self] ad, _ in
            guard let self, let ad else {
                Logger.debug(
                    "Fail to load reward ad. \(AdMobKey.codeKeyReward.description ?? "")",
                    userInfo: [.category: "ADMOB"]
                )
                
                return
            }
            
            Logger.debug(
                "Reward ad loaded. \(AdMobKey.codeKeyReward.description ?? "")",
                userInfo: [.category: "ADMOB"]
            )
            
            self.rewardedAD = ad
            ad.present(fromRootViewController: self) { [weak self] in
                self?.rewardedAD = nil
                self?.reducer.action(.getReward)
            }
        }
    }
}

extension SettingViewController: SettingControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

extension SettingViewController: NoticeListControllerDelegate { }

extension SettingViewController: MyCodesControllerDelegate { }

extension SettingViewController: BlockedCodesControllerDelegate { }

extension SettingViewController: OpenSourceLicenseListControllerDelegate { }

@ViewBuilder
private func Root(
    menus: Menus,
    onBackTap: @escaping () -> Void
) -> some View {
    VStack(spacing: 0) {
        NavigationBar(
            title: menus.title,
            onBackTap: onBackTap
        )
        menus
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
class SettingMockRouter: SettingRoutable {
    class NoticeList: ComposableController, NoticeListControllable {
        weak var delegate: (any NoticeListControllerDelegate)?
    }
    
    class MyCodes: ComposableController, MyCodesControllable {
        weak var delegate: (any MyCodesControllerDelegate)?
    }
    
    class BlockedCodes: ComposableController, BlockedCodesControllable {
        weak var delegate: (any BlockedCodesControllerDelegate)?
    }
    
    class OpenSourceLicenseList: ComposableController, OpenSourceLicenseListControllable {
        weak var delegate: (any OpenSourceLicenseListControllerDelegate)?
    }
    
    func routeToSetting(with parameter: SettingParameter) -> SettingControllable {
        SettingViewController(
            router: SettingMockRouter(),
            reducer: .init(proxy: .init(initialState: .init())),
            menus: parameter.menus
        )
    }
    
    func routeToNoticeList(with parameter: NoticeListParameter) -> any NoticeListControllable {
        NoticeList {
            Text("Notice List")
        }
    }
    
    func routeToMyCodes(with parameter: MyCodesParameter) -> any MyCodesControllable {
        MyCodes {
            Text("My Codes")
        }
    }
    
    func routeToBlockedCodes(with parameter: BlockedCodesParameter) -> BlockedCodesControllable {
        BlockedCodes {
            Text("Blocked Codes")
        }
    }
    
    func routeToOpenSourceLicenseList(with parameter: OpenSourceLicenseListParameter) -> any OpenSourceLicenseListControllable {
        OpenSourceLicenseList {
            Text("Open Source License List")
        }
    }
}

struct Setting_Preview: View {
    var body: some View {
        SettingViewController(
            router: SettingMockRouter(),
            reducer: .init(proxy: .init(initialState: .init())),
            menus: nil
        )
            .rootView
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting_Preview()
    }
}
#endif
