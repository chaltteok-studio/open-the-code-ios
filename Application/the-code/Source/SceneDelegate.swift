//
//  SceneDelegate.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import UIKit
import App

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Property
    var window: UIWindow?
    
    private var app: (any AppControllable)? {
        (UIApplication.shared.delegate as? AppDelegate)?.app
    }
    
    // MARK: - Lifecycle
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        window = app?.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        app?.sceneWillEnterForeground(scene)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
