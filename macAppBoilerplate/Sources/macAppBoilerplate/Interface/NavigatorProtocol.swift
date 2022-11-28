//
//  NavigatorProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

public protocol NavigatorProtocol {
    var navigatorItems: [SidebarDockIcon] { get set }
    func viewForNavigationSidebar(selection: Int) -> AnyView
}

class DefaultNavigatorProtocol: NavigatorProtocol {
    var navigatorItems: [SidebarDockIcon] = []

    func viewForNavigationSidebar(selection: Int) -> AnyView {
        MainContentWrapper {
            Text("Needs Implementation: \(selection)")
        }
    }
}
