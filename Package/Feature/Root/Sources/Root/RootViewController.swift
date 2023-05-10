//
//  RootViewController.swift
//  
//
//  Created by JSilver on 2023/01/28.
//

import Feature
import Launch
import EnterCode

public protocol RootControllable: UIViewControllable {
    
}

final class RootViewController: UINavigationController, RootControllable {
    // MARK: - View

    // MARK: - Property
    var router: (any RootRoutable)?
    
    // MARK: - Initializer

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        
    }
    
    private func setUpState() {
        // Hide top navigtaion bar
        navigationBar.isHidden = true
        
        // Route to launch.
        presentLaunch(animated: false)
    }
    
    private func setUpAction() {
        
    }
    
    /// Present `Launch` module.
    func presentLaunch(
        animated: Bool,
        force: Bool = true,
        completion: ((LaunchControllable) -> Void)? = nil
    ) {
        guard let launch = router?.routeToLaunch(with: .init())
        else { return }
        
        launch.delegate = self
        
        delegate = launch
        
        route(to: self, animated: true) {
            $0?.setViewControllers(
                [launch],
                animated: animated
            )
        }
    }
    
    /// Present `Main` module.
    func presentMain(
        animated: Bool,
        force: Bool = true,
        completion: ((EnterCodeControllable) -> Void)? = nil
    ) {
        guard let enterCode = router?.routeToMain(with: .init()) else { return }
        
        route(to: self, animated: true) {
            $0?.setViewControllers(
                [enterCode],
                animated: animated
            )
        }
    }
}

extension RootViewController: LaunchControllerDelegate {
    func launch(_ launchController: LaunchControllable, didComplete state: LaunchState) {
        guard state == .completed else { return }
        presentMain(animated: true)
    }
}
