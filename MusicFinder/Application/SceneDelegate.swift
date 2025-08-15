//
//  SceneDelegate.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import SwiftUI
import UIKit

/// Use SceneDelegate for setup navigation stack on UIKit and initialize coordinator
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let router = Router(window: window)
        window.makeKeyAndVisible()
        self.window = window
        
        mainCoordinator = MainCoordinator(router: router)
        mainCoordinator?.start()
    }
}
