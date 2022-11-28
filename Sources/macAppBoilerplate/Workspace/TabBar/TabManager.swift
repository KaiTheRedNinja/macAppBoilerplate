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
    @Published var openedTabs: [any TabBarItemRepresentable] {
        didSet {
            if dataSource.disableTabs && !openedTabs.isEmpty {
                self.openedTabs = []
            }
        }
    }

    /// The currently selected tab
    @Published var selectedTab: TabBarID?

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
    ///   - removeAllOccurences: If it should remove all duplicate instances (defaults to true)
    ///   - refocus: If the selected tab should be refocused if the closed tab was selected (defaults to true)
    public func closeTab(id: TabBarID?, removeAllOccurences: Bool = true, refocus: Bool = true) {
        guard let id else { return }

        if dataSource.disableTabs && id.id == selectedTab?.id {
            selectedTab = nil
            return
        }

        if refocus && id.id == selectedTab?.id,
           let firstIndex = openedTabs.firstIndex(where: { $0.tabID.id == id.id }) {
            let index = (firstIndex + 1) % openedTabs.count
            selectedTab = openedTabs[index].tabID
        } else {
            selectedTab = nil
        }

        if removeAllOccurences {
            openedTabs.removeAll(where: { $0.tabID.id == id.id })
        } else if let index = openedTabs.firstIndex(where: { $0.tabID.id == id.id }) {
            openedTabs.remove(at: index)
        }
    }

    /// Opens a given tab
    /// - Parameters:
    ///   - tab: The TabBarItemRepresentable
    ///   - origin: The item that it originates from. If provided, the tab opens to the right of that item.
    ///   - focus: If the tab should be automatically focused
    public func openTab(tab: any TabBarItemRepresentable, from origin: (any TabBarItemRepresentable)? = nil, focus: Bool = true) {
        if (openedTabs.contains(where: { $0.tabID.id == tab.tabID.id }) && focus) || dataSource.disableTabs {
            selectedTab = tab.tabID
            return
        }

        if let origin, let originIndex = openedTabs.firstIndex(where: { $0.tabID.id == origin.tabID.id }) {
            openedTabs.insert(tab, at: originIndex+1)
        } else {
            openedTabs.append(tab)
        }

        if focus {
            selectedTab = tab.tabID
        }
    }
}

extension TabManager: Equatable {
    public static func == (lhs: TabManager, rhs: TabManager) -> Bool {
        lhs.openedTabs.count == rhs.openedTabs.count && lhs.selectedTab?.id == rhs.selectedTab?.id
    }
}
