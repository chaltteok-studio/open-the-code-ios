//
//  RoomViewController.swift
//  
//
//  Created by JSilver on 2023/03/17.
//

import Feature
import MessageUI
import GoogleMobileAds

public protocol RoomControllerDelegate: AnyObject {
    func back()
}

public protocol RoomControllable: UIViewControllable {
    var delegate: (any RoomControllerDelegate)? { get set }
}

final class RoomViewController: ComposableController, RoomControllable {
    final private class Environment: ObservableObject {
        /// AdMob data.
        @Published
        var nativeAD: GADNativeAd?
        /// The code copied toast show.
        @Published
        var isCopiedToastShow: Bool = false
        /// The code block tapped signal.
        @Published
        var blockTapped: Void?
    }
    
    // MARK: - Property
    private let router: any RoomRoutable
    weak var delegate: (any RoomControllerDelegate)?
    
    private let env: Environment
    private var adLoader: GADAdLoader?

    // MARK: - Initializer
    init(
        router: any RoomRoutable,
        reducer: Reducer<RoomViewReduce>
    ) {
        self.router = router
        
        let env = Environment()
        self.env = env
        
        super.init(env, reducer)
        run { [weak self] in
            Root(
                ad: env.nativeAD,
                code: reducer.state.code,
                description: reducer.state.description,
                isOwner: reducer.state.isOwner,
                isLoading: reducer.state.isLoading,
                onBackTap: {
                    self?.delegate?.back()
                },
                onReportTap: {
                    self?.report(code: reducer.state.code)
                },
                onCopyTap: {
                    UIPasteboard.general.string = reducer.state.code
                    env.isCopiedToastShow = true
                },
                onDeleteTap: {
                    reducer.action(.deleteCode)
                },
                onBlockTap: {
                    env.blockTapped = Void()
                }
            )
                // The code copied toast
                .toast(
                    .object(env, path: \.isCopiedToastShow),
                    duration: 2,
                    layouts: [
                        .inside(.top, offset: 24),
                        .center(.x)
                    ],
                    showAnimation: .slideIn(
                        duration: 0.2,
                        direction: .down
                    )
                ) {
                    Text(TR.Localization.roomCodeCopyToastTitle)
                        .foregroundColor(Color(uiColor: CR.Color.gray05))
                        .font(Font(TR.Font.font(ofSize: 18)))
                        .padding()
                        .background(
                            Capsule().foregroundColor(Color(uiColor: CR.Color.gray03))
                        )
                }
                // The code block confirm alert
                .alert(
                    env.$blockTapped
                        .compactMap { $0 }
                ) { _, dismiss in
                    TCAlert(
                        TR.Localization.roomCodeBlockConfirmAlertTitle,
                        description: TR.Localization.roomCodeBlockConfirmAlertDescription
                    ) {
                        TCAlertAction(TR.Localization.errorAlertActionCancelTitle) {
                            dismiss(nil)
                        }
                        TCAlertAction(
                            TR.Localization.roomCodeBlockConfirmAlertActionBlockTitle,
                            style: .destructive
                        ) {
                            dismiss {
                                reducer.action(.blockCode)
                            }
                        }
                    }
                }
                // The code deleted alert
                .alert(
                    reducer.$state.map(\.$codeDeleted)
                        .removeDuplicates()
                        .compactMap(\.value)
                ) { _, dismiss in
                    TCAlert(
                        TR.Localization.roomCodeDeletedAlertTitle,
                        description: TR.Localization.roomCodeDeletedAlertDescription
                    ) {
                        TCAlertAction(TR.Localization.errorAlertActionConfirmTitle) {
                            dismiss {
                                self?.delegate?.back()
                            }
                        }
                    }
                }
                // The code blocked alert
                .alert(
                    reducer.$state.map(\.$codeBlocked)
                        .removeDuplicates()
                        .compactMap(\.value)
                ) { _, dismiss in
                    TCAlert(
                        TR.Localization.roomCodeBlockedAlertTitle,
                        description: TR.Localization.roomCodeBlockedAlertDescription
                    ) {
                        TCAlertAction(TR.Localization.errorAlertActionConfirmTitle) {
                            dismiss {
                                self?.delegate?.back()
                            }
                        }
                    }
                }
                .error(
                    reducer.$state.map(\.$error)
                        .removeDuplicates()
                        .compactMap(\.value)
                )
                .onAppear {
                    self?.loadAD()
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
    private func loadAD() {
        guard let adLoader else {
            let adLoader = GADAdLoader(
                adUnitID: AdMobKey.roomBanner.rawValue,
                rootViewController: self,
                adTypes: [.native],
                options: []
            )
            
            adLoader.delegate = self
            adLoader.load(GADRequest())
            
            self.adLoader = adLoader
            return
        }
        
        adLoader.load(GADRequest())
    }
    
    private func report(code: String) {
        guard MFMailComposeViewController.canSendMail() else { return }
        
        let viewController = MFMailComposeViewController()
        viewController.setToRecipients([Env.Constant.csEmail])
        viewController.setSubject(TR.Localization.roomReportSubject)
        viewController.setMessageBody(
            String(format: TR.Localization.roomReportMessage, code),
            isHTML: false
        )
        viewController.mailComposeDelegate = self
        
        present(viewController, animated: true)
    }
}

extension RoomViewController: GADNativeAdLoaderDelegate, GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        Logger.debug(
            "AD did received. \(AdMobKey.roomBanner.description ?? "unknown")",
            userInfo: [.category: "ADMOB"]
        )
        env.nativeAD = nativeAd
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        // The adLoader has finished loading ads, and a new request can be sent.
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        Logger.debug(
            "AD did fail to receive. \(AdMobKey.roomBanner.description ?? "unknown")",
            userInfo: [.category: "ADMOB"]
        )
    }
}

extension RoomViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.presentingViewController?.dismiss(animated: true)
    }
}

@ViewBuilder
private func Root(
    ad: GADNativeAd?,
    code: String,
    description: String,
    isOwner: Bool,
    isLoading: Bool,
    onBackTap: @escaping () -> Void,
    onReportTap: @escaping () -> Void,
    onCopyTap: @escaping () -> Void,
    onDeleteTap: @escaping () -> Void,
    onBlockTap: @escaping () -> Void
) -> some View {
    GeometryReader { _ in
        VStack(spacing: 0) {
            NavigationBar(
                onBackTap: onBackTap,
                onReportTap: onReportTap
            )
            
            NativeADView(ad)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
            
            CodeContent(
                code: code,
                description: description,
                onCopyTap: onCopyTap
            )
            
            if isOwner {
                CSUButton(title: TR.Localization.roomCodeDeleteButtonTitle) {
                    onDeleteTap()
                }
                .csuButton(\.style, .tcFill)
                .csuButton(\.isLoading, isLoading)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .fixedSize(horizontal: false, vertical: true)
            } else {
                CSUButton(title: TR.Localization.roomCodeBlockButtonTitle) {
                    onBlockTap()
                }
                .csuButton(\.style, .tcFill)
                .csuButton(\.isLoading, isLoading)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .fixedSize(horizontal: false, vertical: true)
            }
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
    onBackTap: @escaping () -> Void,
    onReportTap: @escaping () -> Void
) -> some View {
    ZStack {
        CSUNavigationBar("")
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
            .csuNavigationBar(
                \.rightAccessories,
                 [
                    CSUButton(image: Image(uiImage: CR.Icon.ic24Notice)) {
                        onReportTap()
                    }
                        .csuButton(\.style, .tcPlain)
                        .fixedSize()
                 ]
            )
            .fixedSize(horizontal: false, vertical: true)
    }
}

@ViewBuilder
private func CodeContent(
    code: String,
    description: String,
    onCopyTap: @escaping () -> Void
) -> some View {
    VStack(spacing: 0) {
        HStack(spacing: 4) {
            Image(uiImage: CR.Icon.ic16Password)
            Text(code)
            
            Spacer()
            
            CSUButton(image: Image(uiImage: CR.Icon.ic24Link)) {
                onCopyTap()
            }
                .csuButton(\.style, .tcPlain)
                .fixedSize()
        }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        
        Rectangle().frame(height: 1)
            .padding(.horizontal, 20)
        
        ScrollView {
            HStack {
                Text(description)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .padding(.bottom, 80)
        }
    }
        .font(Font(TR.Font.font(ofSize: 18)))
        .foregroundColor(Color(uiColor: CR.Color.gray05))
}

#if DEBUG
import SwiftUI

class RoomMockRouter: RoomRoutable { }

struct Room_Preview: View {
    var body: some View {
        RoomViewController(
            router: RoomMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init(
                    code: "ASDF",
                    description: "CodeQuisque ligula ligula, feugiat porta tortor quis, imperdiet aliquam ipsum. Proin at purus dapibus, eleifend dui ut, porttitor sem. Quisque nec mauris augue. Etiam vitae metus diam. Proin tempus dolor at orci vehicula semper. Suspendisse id iaculis sapien, dignissim pharetra sem. Pellentesque blandit lacinia urna ut dapibus. Pellentesque eget nunc tincidunt, congue nunc sollicitudin, convallis orci. Praesent bibendum enim ac egestas semper. Nunc elit quam, dictum sed accumsan sit amet, viverra ut arcu.CodeQuisque ligula ligula, feugiat porta tortor quis, imperdiet aliquam ipsum. Proin at purus dapibus, eleifend dui ut, porttitor sem. Quisque nec mauris augue. Etiam vitae metus diam. Proin tempus dolor at orci vehicula semper. Suspendisse id iaculis sapien, dignissim pharetra sem. Pellentesque blandit lacinia urna ut dapibus. Pellentesque eget nunc tincidunt, congue nunc sollicitudin, convallis orci. Praesent bibendum enim ac egestas semper. Nunc elit quam, dictum sed accumsan sit amet, viverra ut arcu.",
                    isOwner: true,
                    isLoading: false
                )
            ))
        )
            .rootView
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room_Preview()
    }
}
#endif
