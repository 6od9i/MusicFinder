//
//  HostingController+UIKitNavBar.swift
//  MusicFinder
//
//  Created by 6od9i on 08/08/25.
//

import SwiftUI
import UIKit

class HostingController<Content: View>: UIHostingController<Content> {
    private var navBarHidden: Bool
    
    init(rootView: Content, navBarHidden: Bool) {
        self.navBarHidden = navBarHidden
        super.init(rootView: rootView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController, navigationController.isNavigationBarHidden != navBarHidden {
            navigationController.setNavigationBarHidden(navBarHidden, animated: animated)
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
