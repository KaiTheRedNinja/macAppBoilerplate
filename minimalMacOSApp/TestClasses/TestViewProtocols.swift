//
//  TestViewProtocols.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI
import macAppBoilerplate

class TestViewProtocol: NavigatorProtocol, InspectorProtocol, WorkspaceProtocol {
    // MARK: Navigator protocol
    var navigatorItems: [SidebarDockIcon] = [
        .init(imageName: "circle", title: "test0", id: 0),
        .init(imageName: "square", title: "test1", id: 1),
        .init(imageName: "triangle", title: "test2", id: 2)
    ]

    func viewForNavigationSidebar(selection: Int) -> AnyView {
        MainContentWrapper {
            ZStack {
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

    // MARK: Inspector protocol
    var inspectorItems: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]

    func viewForInspectorSidebar(selection: Int) -> AnyView {
        MainContentWrapper {
            Text("Selection: \(selection)")
        }
    }

    // MARK: Workspace protocol
    func viewForWorkspace(tab: TabBarID) -> AnyView {
        MainContentWrapper {
            ZStack {
                if let tab = tab as? TestTabBarID {
                    switch tab {
                    case .test(let string):
                        Text("Test: \(string)")
                    }
                } else {
                    Text("Wrong Format")
                }
            }
        }
    }
}
