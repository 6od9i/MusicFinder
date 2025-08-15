//
//  RoutingProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import SwiftUI
import UIKit

protocol RoutingProtocol {
    func setRoot<T: View>(view: T, navBarHidden: Bool)
    func push<T: View>(view: T, navBarHidden: Bool)
    func pop()
    func present<T: View>(view: T)
    func dismiss()
}
