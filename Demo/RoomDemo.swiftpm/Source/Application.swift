//
//  Application.swift
//
//
//  Created by JSilver on 2023/05/30.
//

import SwiftUI
import GoogleMobileAds
import Logger
import Network
import Environment
import API
import Storage
import UserService
import CodeService
import TCUIKit
import Room

struct Dependency: RoomDependency {
    let userService: any UserServiceable
    let codeService: any CodeServiceable
    
    init() {
        let userDefaultStorage = UserDefaultStorage()
        
        let networkProvider = URLNetworkProvider(
            interceptors: [
                LogInterceptor(),
                APILimitInterceptor {
                    (try? userDefaultStorage.read(forKey: StoreKey.limitAPICall.rawValue)) ?? false
                },
                HeaderInterceptor(
                    key: "Accept-Language",
                    value: Env.locale.rawValue
                ),
                CachePolicyInterceptor()
            ]
        )
        
        let userService = UserService(storage: userDefaultStorage)
        let codeService = CodeService(
            storage: userDefaultStorage,
            provider: networkProvider,
            userService: userService
        )
        
        self.userService = userService
        self.codeService = codeService
    }
}

struct NavigationController: UIViewControllerRepresentable {
    // MARK: - Property
    private let rootViewController: UIViewController
    
    // MARK: - Initializer
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - Lifecycle
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.navigationBar.isHidden = true
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

@main
struct Application: App {
    // MARK: - View
    var body: some Scene {
        WindowGroup {
            NavigationController(
                rootViewController: RoomBuilder(dependency)
                    .build(with: .init(
                        code: .init(
                            code: "demo",
                            author: "",
                            createdAt: Date(),
                            content: "Demo"
                        )
                    ))
            )
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }

    // MARK: - Property
    let dependency: Dependency

    // MARK: - Initializer
    init() {
        Application.setUpApplication()
        
        self.dependency = Dependency()
    }

    // MARK: - Public
    
    // MARK: - Private
    private static func setUpApplication() {
        Env.config = .develop
        
        setUpLogger()
        setUpGoogleAdMob()
        setUpFonts()
    }
    
    private static func setUpLogger() {
        guard Env.config != .deploy else { return }
        Logger.configure([ConsolePrinter()])
    }
    
    private static func setUpGoogleAdMob() {
        GADMobileAds.sharedInstance().start()

        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = []
        #if targetEnvironment(simulator)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers?.append(GADSimulatorID)
        #endif
    }
    
    private static func setUpFonts() {
        TR.Font.registerFonts()
    }
}
