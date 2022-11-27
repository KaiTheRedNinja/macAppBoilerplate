//
//  MainWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSToolbarDelegate {

    var navigatorProtocol: some NavigatorProtocol = DefaultNavigatorProtocol()
    var inspectorProtocol: some InspectorProtocol = DefaultInspectorProtocol()

    @ViewBuilder
    func viewForNavigationSidebar(selection: Int) -> some View {
        switch selection {
        case 0:
            OutlineView { _ in
                TestOutlineViewController()
            }
        default:
            SidebarContainer {
                Text("Needs Implementation")
            }
        }
    }

    @ViewBuilder
    func viewForInspectorSidebar(selection: Int) -> some View {
        SidebarContainer {
            Text("Needs Implementation")
        }
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
