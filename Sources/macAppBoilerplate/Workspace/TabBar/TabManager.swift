//
//  TabManager.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

//let disableTabs: Bool = false

/// Manages tab state, including open tabs, and manipulating tabs
public final class TabManager: ObservableObject {

    /// Data source
    var dataSource: any TabBarProtocol { didSet {
        self.openedTabs = dataSource.disableTabs ? [] : openedTabs
    }}

    init(dataSource: TabBarProtocol = DefaultTabBarProtocol(),
         openedTabs: [any TabBarItemRepresentable] = [],
         initialTab: TabBarID? = nil) {
        self.dataSource = dataSource
        self.openedTabs = dataSource.disableTabs ? [] : openedTabs
        self.selectedTab = initialTab
    }

    /// List of opened tabs
    @Published public private(set) var openedTabs: [any TabBarItemRepresentable] {
        didSet {
            if dataSource.disableTabs && !openedTabs.isEmpty {
                self.openedTabs = []
            }
        }
    }

    /// The currently selected tab
    @Published public private(set) var selectedTab: TabBarID?

    /// Gets the tab representable for the selected tab
    public func selectedTabItem() -> (any TabBarItemRepresentable)? {
        return tabForID(id: selectedTab)
    }

    /// Gets the tab representable for any given tab ID
    public func tabForID(id: TabBarID?) -> (any TabBarItemRepresentable)? {
        guard let id else { return nil }
        return openedTabs.first(where: { $0.tabID.id == id.id })
    }

    /// Close a given tab
    /// - Parameters:
    ///   - id: The Tab Bar ID to close
    ///   - refocus: If the selected tab should be refocused if the closed tab was selected (defaults to true).
    ///   If set to false and the closed tab was the current tab, the selected tab will be set to nil (AKA no tab open).
    public func closeTab(id: TabBarID?, refocus: Bool = true) {
        guard let id else { return }

        // if tabs are disabled, just deselect the tab
        if dataSource.disableTabs {
            selectedTab = nil
            return
        }

        // if the closed tab is the current tab
        if id.id == selectedTab?.id {
            // refocus                  -> if selection is not to be refocused, set selection to nil
            // let firstIndex           -> gets the index of the closed tab
            // openedTabs.count > 1     -> makes sure that there is at least 1 tab to take the selection
            if refocus, let firstIndex = openedTabs.firstIndex(where: { $0.tabID.id == id.id }), openedTabs.count > 1 {
                // get the next index, but modulo it to the opened tab count to prevent access out of bounds errors
                let index = (firstIndex + 1) % openedTabs.count
                selectedTab = openedTabs[index].tabID
            } else {
                // if not refocus or the index was not found, set the selected tab to nil
                selectedTab = nil
            }
        }
        // else, do nothing as the current tab did not change

        // there should not be multiple tabs with the same ID, so just close all tabs that match the id.
        openedTabs.removeAll(where: { $0.tabID.id == id.id })
    }

    /// Opens a given tab
    /// - Parameters:
    ///   - tab: The TabBarItemRepresentable
    ///   - origin: The item that it originates from. If provided, the tab opens to the right of that item.
    ///   - focus: If the tab should be automatically focused
    public func openTab(tab: any TabBarItemRepresentable, from origin: (any TabBarItemRepresentable)? = nil, focus: Bool = true) {
        // if the tab is already open or tabs are disabled, just select it
        if (openedTabs.contains(where: { $0.tabID.id == tab.tabID.id }) && focus) || dataSource.disableTabs {
            selectedTab = tab.tabID
            return
        }

        // if the origin is specified, insert the tab to the right of the origin tab
        // else, just open it at the extreme right
        if let origin, let originIndex = openedTabs.firstIndex(where: { $0.tabID.id == origin.tabID.id }) {
            openedTabs.insert(tab, at: originIndex+1)
        } else {
            openedTabs.append(tab)
        }

        // focus the tab
        if focus {
            selectedTab = tab.tabID
        }
    }

    /// Replaces existing tabs with a new set of tabs
    /// - Parameter newTabs: The tabs to replace the old tabs with
    public func setTabsTo(newTabs: [any TabBarItemRepresentable]) {
        openedTabs = newTabs

        // make sure that the selected tab is in this new list
        if !openedTabs.map({ $0.tabID }).contains(where: { $0.id == selectedTab?.id }) {
            selectedTab = nil
        }
    }
}

extension TabManager: Equatable {
    public static func == (lhs: TabManager, rhs: TabManager) -> Bool {
        lhs.openedTabs.count == rhs.openedTabs.count && lhs.selectedTab?.id == rhs.selectedTab?.id
    }
}
