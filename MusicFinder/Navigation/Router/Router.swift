//
//  Router.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import SwiftUI
import UIKit

/// Router for UIKit navigation
final class Router: NSObject {
    /// Window for showing top above all screens and replacing navControllers
    private let window: UIWindow
    /// Current navigation stack controlled by navController in router
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        let navController = UINavigationController()
        navController.isNavigationBarHidden = true
        window.rootViewController = navController
        self.navigationController = navController
        super.init()
        navController.interactivePopGestureRecognizer?.isEnabled = true
        navController.interactivePopGestureRecognizer?.delegate = self
    }
}

extension Router: RoutingProtocol {
    func setRoot<T: View>(view: T, navBarHidden: Bool) {
        navigationController.setViewControllers(
            [HostingController(rootView: view, navBarHidden: navBarHidden)],
            animated: true)
    }
    
    func push<T>(view: T, navBarHidden: Bool) where T: View {
        let vc = HostingController(rootView: view, navBarHidden: navBarHidden)
        push(view: vc)
    }
    
    func push(view: UIViewController) {
        navigationController.pushViewController(view, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func present<T>(view: T) where T: View {
        present(view: UIHostingController(rootView: view))
    }
    
    func present(view: UIViewController) {
        navigationController.present(view, animated: true, completion: nil)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension Router: UIGestureRecognizerDelegate {}
