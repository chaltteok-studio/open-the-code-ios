//
//  App.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import UIKit
import RVB
import Logger
import GoogleMobileAds
import Firebase
import Environment
import TCUIKit
import CodeService

public protocol AppControllable: AnyObject, Controllable {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    func sceneWillEnterForeground(_ scene: UIScene)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) -> UIWindow?
}

final class App: AppControllable {
    // MARK: - Property
    private let router: any AppRoutable
    private let codeService: any CodeServiceable
    
    // MARK: - Initializer
    init(
        router: any AppRoutable,
        codeService: any CodeServiceable
    ) {
        self.router = router
        self.codeService = codeService
    }
    
    // MARK: - Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpApplication()
        
        return true
    }	
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        Task {
            try await codeService.checkCodeKeysRecovery()
        }
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) -> UIWindow? {
        guard let windowScene = (scene as? UIWindowScene) else { return nil }
        
        let root = router.routeToRoot(with: .init())
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = root
        window.makeKeyAndVisible()
        
        return window
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUpApplication() {
        setUpLogger()
        setUpFirebase()
        setUpGoogleAdMob()
        setUpFonts()
    }
    
    private func setUpLogger() {
        guard Env.config != .deploy else { return }
        Logger.configure([ConsolePrinter()])
    }
    
    private func setUpFirebase() {
        #if DEBUG
        #else
        FirebaseApp.configure()
        #endif
    }
    
    private func setUpGoogleAdMob() {
        GADMobileAds.sharedInstance().start()
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = []
        #if targetEnvironment(simulator)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers?.append(GADSimulatorID)
        #endif
    }
    
    private func setUpFonts() {
        TR.Font.registerFonts()
    }
}
