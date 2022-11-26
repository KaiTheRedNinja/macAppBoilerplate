//
//  MainWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSToolbarDelegate {

    var navigatorItems: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]

    var inspectorItems: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]

    @ViewBuilder
    func viewForNavigationSidebar(selection: Int) -> some View {
        switch selection {
        case 0:
            OutlineView { _ in
                TestOutlineViewController()
            }
        default:
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Text("Needs Implementation")
                    Spacer()
                }
            }
            .frame(maxHeight: .infinity)
        }
    }

    @ViewBuilder
    func viewForInspectorSidebar(selection: Int) -> some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text("Needs Implementation")
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    func viewForWorkspace(tab: TabBarID) -> some View {
        if let tab = tab as? TestTabBarID {
            switch tab {
            case .test(let string):
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Test: \(string)")
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Text("Wrong Format")
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var items: [NSToolbarItem.Identifier] = []
        items.append(contentsOf: defaultLeadingItems(toolbar))
        // add additional toolbar items here
        items.append(.flexibleSpace)
        items.append(contentsOf: defaultTrailingItems(toolbar))
        return items
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var items: [NSToolbarItem.Identifier] = []
        items.append(contentsOf: defaultLeadingItems(toolbar))
        // add additional toolbar items here
        items.append(contentsOf: defaultTrailingItems(toolbar))
        return items
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        if let defaultItem = builtinDefaultToolbar(toolbar,
                                                   itemForItemIdentifier: itemIdentifier,
                                                   willBeInsertedIntoToolbar: flag) {
            return defaultItem
        }

        switch itemIdentifier {
        // put your toolbar items in here
        default:
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }
}

private extension NSToolbarItem.Identifier {
    // add custom NSToolbarItem Identifiers using the following format:
    // static let yourItem = NSToolbarItem.Identifier("YourItem")
}
