//
//  MainWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import Cocoa
import SwiftUI

open class MainWindowController: NSWindowController, NSToolbarDelegate {

    /// The ``SidebarProtocol`` used for the Navigator Sidebar
    var navigatorProtocol: (any SidebarProtocol)!
    /// The ``SidebarProtocol`` used for the Inspector Sidebar
    var inspectorProtocol: (any SidebarProtocol)!
    /// The ``WorkspaceProtocol`` used for the main workspace content
    var workspaceProtocol: (any WorkspaceProtocol)!

    /// Gets a ``SidebarProtocol``, defaulting to ``DefaultSidebarProtocol`` if not overridden.
    open func getNavigatorProtocol() -> any SidebarProtocol { DefaultSidebarProtocol() }
    /// Gets a ``SidebarProtocol``, defaulting to ``DefaultSidebarProtocol`` if not overridden.
    open func getInspectorProtocol() -> any SidebarProtocol { DefaultSidebarProtocol() }
    /// Gets a ``WorkspaceProtocol``, defaulting to ``DefaultWorkspaceProtocol`` if not overridden.
    open func getWorkspaceProtocol() -> any WorkspaceProtocol { DefaultWorkspaceProtocol() }

    /// Gets a ``TabBarProtocol``, defaulting to ``DefaultTabBarProtocol`` if not overridden
    open func getTabBarProtocol() -> any TabBarProtocol { DefaultTabBarProtocol() }

    /// Inherited from ``NSToolbarDelegate.toolbarDefaultItemIdentifiers(_:).``
    open func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var items: [NSToolbarItem.Identifier] = []
        items.append(contentsOf: defaultLeadingItems(toolbar))
        // add additional toolbar items here
        items.append(.flexibleSpace)
        items.append(contentsOf: defaultTrailingItems(toolbar))
        return items
    }

    /// Inherited from ``NSToolbarDelegate.toolbarAllowedItemIdentifiers(_:).``
    open func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var items: [NSToolbarItem.Identifier] = []
        items.append(contentsOf: defaultLeadingItems(toolbar))
        // add additional toolbar items here
        items.append(contentsOf: defaultTrailingItems(toolbar))
        return items
    }

    /// Inherited from ``NSToolbarDelegate.toolbar(_:itemForItemIdentifier:willBeInsertedIntoToolbar:).``
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
