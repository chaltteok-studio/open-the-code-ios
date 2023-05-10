//
//  EnterCodeViewController.swift
//  
//
//  Created by JSilver on 2023/01/29.
//

import Feature
import GoogleMobileAds
import CodeService
import Room

public protocol EnterCodeControllable: UIViewControllable {
    
}

final class EnterCodeViewController: ComposableController, EnterCodeControllable {
    final class Environment: ObservableObject {
        /// AdMob data.
        @Published
        var nativeAD: GADNativeAd?
        /// Code input.
        @Published
        var code: String
        /// Code input text field focused.
        @Published
        var codeFocused: Bool
        /// Remaining time that additional code key genenration.
        @Published
        var remainingTime: TimeInterval?
        
        init(
            code: String = "",
            codeFocused: Bool = false,
            remainingTime: TimeInterval? = nil
        ) {
            self.code = code
            self.codeFocused = codeFocused
            self.remainingTime = remainingTime
        }
    }
    
    // MARK: - Property
    private let router: any EnterCodeRoutable
    
    private let env: Environment
    private var adLoader: GADAdLoader?
    
    // MARK: - Initializer
    init(router: EnterCodeRoutable, reducer: Reducer<EnterCodeViewReduce>) {
        self.router = router
        
        let env = Environment(
            remainingTime: reducer.state.nextCodeKeyDate?.timeIntervalSince(.now)
        )
        self.env = env
        
        super.init(env, reducer)
        
        reducer.action(.load)
        run { [weak self] in
            Root(
                ad: env.nativeAD,
                totalCodesCount: reducer.state.totalCodesCount,
                code: .object(env, path: \.code),
                codeFocused: .object(env, path: \.codeFocused),
                maxCodeCount: 30,
                remainingKeyCount: reducer.state.remainingKeyCount,
                maxKeyCount: reducer.state.maxKeyCount,
                remainingTime: env.remainingTime,
                isLoading: reducer.state.isLoading,
                onEnterTap: {
                    reducer.action(.enter(code: env.code))
                }
            )
                // Code generation timer.
                .subscribe(
                    Timer.publish(every: 0.25, on: .main, in: .default)
                        .autoconnect()
                ) { _ in
                    let remainingTime = reducer.state.nextCodeKeyDate?.timeIntervalSince(.now)
                    env.remainingTime = remainingTime
                }
                // Code accepted signal.
                .subscribe(
                    reducer.$state.map(\.$codeAccepted)
                        .removeDuplicates()
                        .compactMap(\.value)
                ) {
                    self?.presentRoom(animated: true, code: $0)
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
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public
    
    // MARK: - Private
    private func presentRoom(
        animated: Bool,
        force: Bool = true,
        code: Code,
        completion: ((RoomControllable) -> Void)? = nil
    ) {
        let room = router.routeToRoom(with: .init(
            code: code
        ))
        
        room.delegate = self
        
        route(to: self, animated: animated) {
            $0?.navigationController?.pushViewController(room, animated: animated)
        }
    }
    
    private func loadAD() {
        guard let adLoader else {
            let adLoader = GADAdLoader(
                adUnitID: AdMobKey.mainBanner.rawValue,
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
}

extension EnterCodeViewController: GADNativeAdLoaderDelegate, GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        Logger.debug(
            "AD did received. \(AdMobKey.mainBanner.description ?? "unknown")",
            userInfo: [.category: "ADMOB"]
        )
        env.nativeAD = nativeAd
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        // The adLoader has finished loading ads, and a new request can be sent.
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        Logger.debug(
            "AD did fail to receive. \(AdMobKey.mainBanner.description ?? "unknown")",
            userInfo: [.category: "ADMOB"]
        )
    }
}

// MARK: - Room Delegate
extension EnterCodeViewController: RoomControllerDelegate {
    func back() {
        route(to: self, animated: true)
    }
}

@ViewBuilder
private func Root(
    ad: GADNativeAd?,
    totalCodesCount: Int?,
    code: Binding<String>,
    codeFocused: Binding<Bool>,
    maxCodeCount: Int,
    remainingKeyCount: Int,
    maxKeyCount: Int,
    remainingTime: TimeInterval?,
    isLoading: Bool,
    onEnterTap: @escaping () -> Void
) -> some View {
    GeometryReader { _ in
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    codeFocused.wrappedValue = false
                }
            
            VStack {
                NativeADView(ad)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Spacer(minLength: 48)
                
                CodeView(
                    totalCodesCount: totalCodesCount,
                    code: code,
                    codeFocused: codeFocused,
                    maxCodeCount: maxCodeCount,
                    remainingKeyCount: remainingKeyCount,
                    maxKeyCount: maxKeyCount,
                    remainingTime: remainingTime,
                    isLoading: isLoading,
                    onEnterTap: onEnterTap
                )
                    .keyboardAvoidancing(offset: 32)
                    .padding(.horizontal, 20)
                
                Spacer()
                    .layoutPriority(1)
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
private func CodeView(
    totalCodesCount: Int?,
    code: Binding<String>,
    codeFocused: Binding<Bool>,
    maxCodeCount: Int,
    remainingKeyCount: Int,
    maxKeyCount: Int,
    remainingTime: TimeInterval?,
    isLoading: Bool,
    onEnterTap: @escaping () -> Void
) -> some View {
    VStack(spacing: 10) {
        HStack {
            Group {
                if let totalCodesCount {
                    Text(String(format: TR.Localization.enterCodeTotalCodesCountTitle, totalCodesCount.number))
                        .lineLimit(1)
                } else {
                    Text(String(format: TR.Localization.enterCodeTotalCodesCountTitle, "---"))
                        .lineLimit(1)
                }
            }
                .font(Font(TR.Font.font(ofSize: 16)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
            
            Spacer()
        }
        
        HStack(spacing: 4) {
            Image(uiImage: CR.Icon.ic16Password)
            
            Text(TR.Localization.enterCodeCodeInputTitle)
                .font(Font(TR.Font.font(ofSize: 16)))
            
            Spacer()
            
            Text("\(code.wrappedValue.count)/\(maxCodeCount)")
                .font(Font(TR.Font.font(ofSize: 16)))
                .foregroundColor(Color(uiColor: CR.Color.gray05))
        }
            .foregroundColor(Color(uiColor: CR.Color.gray05))
        
        VStack(spacing: 8) {
            CSUTextField(
                TR.Localization.enterCodeCodeInputPlaceholder,
                text: code
            )
                .csuTextField(\.style, .tcBoxInput())
                .csuTextField(\.validator, .init(.regex(Env.Constant.codeRegex(count: maxCodeCount))))
                .csuTextField(\.isEditing, codeFocused)
                .csuTextField(\.onReturn) {
                    codeFocused.wrappedValue = false
                    onEnterTap()
                }
                .fixedSize(horizontal: false, vertical: true)
            
            CSUButton(title: TR.Localization.enterCodeEnterButtonTitle) {
                codeFocused.wrappedValue = false
                onEnterTap()
            }
                .csuButton(\.style, .tcLine)
                .csuButton(\.isLoading, isLoading)
                .disabled(code.wrappedValue.isEmpty)
                .fixedSize(horizontal: false, vertical: true)
        }
        
        HStack {
            Spacer()
            HStack(spacing: 4) {
                if let remainingTime {
                    Text("\(Date(timeIntervalSince1970: max(ceil(remainingTime), 0)).formatted("mm:ss"))")
                        .font(Font(TR.Font.font(ofSize: 20)))
                        .foregroundColor(Color(uiColor: CR.Color.gray05))
                        .padding(.horizontal, 8)
                }
                
                ForEach(0 ..< remainingKeyCount, id: \.self) { _ in
                    Image(uiImage: CR.Icon.ic24Key)
                        .foregroundColor(Color(uiColor: CR.Color.gray05))
                }
                
                ForEach(0 ..< maxKeyCount - remainingKeyCount, id: \.self) { _ in
                    Image(uiImage: CR.Icon.ic24Key)
                        .foregroundColor(Color(uiColor: CR.Color.gray02))
                }
            }
        }
    }
}

#if DEBUG
import SwiftUI

class EnterCodeMockRouter: EnterCodeRoutable {
    class Room: ComposableController, RoomControllable {
        weak var delegate: (any RoomControllerDelegate)?
    }
    
    func routeToRoom(with paramter: RoomParameter) -> any RoomControllable {
        Room {
            Text("Room")
        }
    }
}

struct EnterCode_Preview: View {
    var body: some View {
        EnterCodeViewController(
            router: EnterCodeMockRouter(),
            reducer: .init(proxy: .init(
                initialState: .init(
                    remainingKeyCount: 5,
                    maxKeyCount: 5,
                    isLoading: false
                )
            ))
        )
            .rootView
    }
}

struct EnterCode_Previews: PreviewProvider {
    static var previews: some View {
        EnterCode_Preview()
    }
}
#endif
