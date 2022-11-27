//
//  NavigatorProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

protocol NavigatorProtocol<NavView> {
    associatedtype NavView: View
    var navigatorItems: [SidebarDockIcon] { get set }
    func viewForNavigationSidebar(selection: Int) -> NavView
}

class DefaultNavigatorProtocol: NavigatorProtocol {
    var navigatorItems: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]

    func viewForNavigationSidebar(selection: Int) -> some View {
        SidebarContainer {
            switch selection {
            case 0:
                OutlineView { _ in
                    TestOutlineViewController()
                }
            default:
                Text("Needs Implementation: \(selection)")
            }
        }
    }
}
