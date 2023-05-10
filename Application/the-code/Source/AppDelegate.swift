//
//  AppDelegate.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import UIKit
import App
import Environment

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Property
    private(set) var app: (any AppControllable)?
    
    // MARK: - Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpApplication()
        
        let app = AppBuilder(.init())
            .build(with: .init())
        self.app = app
        
        return app.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUpApplication() {
        #if DEVELOP
        Env.config = .develop
        #elseif LIVE
        Env.config = .live
        #else
        Env.config = .deploy
        #endif
    }
}
