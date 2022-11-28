//
//  MainWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import Cocoa
import SwiftUI

open class MainWindowController: NSWindowController, NSToolbarDelegate {

    var navigatorProtocol: (any SidebarProtocol)!
    var inspectorProtocol: (any SidebarProtocol)!
    var workspaceProtocol: (any WorkspaceProtocol)!

    open func getNavigatorProtocol() -> any SidebarProtocol { DefaultSidebarProtocol() }
    open func getInspectorProtocol() -> any SidebarProtocol { DefaultSidebarProtocol() }
    open func getWorkspaceProtocol() -> any WorkspaceProtocol { DefaultWorkspaceProtocol() }

    open func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var items: [NSToolbarItem.Identifier] = []
        items.append(contentsOf: defaultLeadingItems(toolbar))
        // add additional toolbar items here
        items.append(.flexibleSpace)
        items.append(contentsOf: defaultTrailingItems(toolbar))
        return items
    }

    open func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var items: [NSToolbarItem.Identifier] = []
        items.append(contentsOf: defaultLeadingItems(toolbar))
        // add additional toolbar items here
        items.append(contentsOf: defaultTrailingItems(toolbar))
        return items
    }

    open func toolbar(
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
