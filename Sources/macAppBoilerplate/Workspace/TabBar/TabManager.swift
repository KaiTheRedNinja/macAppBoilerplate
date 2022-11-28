//
//  TabManager.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

let disableTabs: Bool = false

public final class TabManager: ObservableObject {
    public static let shared: TabManager = .init()

    private init(openedTabs: [any TabBarItemRepresentable] = [], initialTab: TabBarID? = nil) {
        self.openedTabs = disableTabs ? [] : openedTabs
        self.selectedTab = initialTab
    }

    @Published var openedTabs: [any TabBarItemRepresentable] {
        didSet {
            if disableTabs && !openedTabs.isEmpty {
                self.openedTabs = []
            }
        }
    }

    @Published var selectedTab: TabBarID?

    public func selectedTabItem() -> (any TabBarItemRepresentable)? {
        return tabForID(id: selectedTab)
    }

    public func tabForID(id: TabBarID?) -> (any TabBarItemRepresentable)? {
        guard let id else { return nil }
        return openedTabs.first(where: { $0.tabID.id == id.id })
    }

    public func closeTab(id: TabBarID?, removeAllOccurences: Bool = true, refocus: Bool = true) {
        guard let id else { return }

        if disableTabs && id.id == selectedTab?.id {
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

    public func openTab(tab: any TabBarItemRepresentable, from origin: (any TabBarItemRepresentable)? = nil, focus: Bool = true) {
        if (openedTabs.contains(where: { $0.tabID.id == tab.tabID.id }) && focus) || disableTabs {
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
