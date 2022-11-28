//
//  TestWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

class TestWindowController: MainWindowController {
    override func getNavigatorProtocol() -> any NavigatorProtocol {
        TestNavigatorProtocol()
    }
}

class TestNavigatorProtocol: NavigatorProtocol {
    var navigatorItems: [SidebarDockIcon] = [
        .init(imageName: "circle", title: "test0", id: 0),
        .init(imageName: "square", title: "test1", id: 1),
        .init(imageName: "triangle", title: "test2", id: 2)
    ]

    func viewForNavigationSidebar(selection: Int) -> AnyView {
        MainContentWrapper {
            Text("Selection: \(selection)")
        }
    }
}
