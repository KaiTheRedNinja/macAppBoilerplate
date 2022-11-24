//
//  TabManager.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

let disableTabs: Bool = false

class TabManager: ObservableObject {
    static let shared: TabManager = .init(openedTabs: [
        TestElement("hi"),
        TestElement("TEST"),
        TestElement("BOOO"),
        TestElement("HELLOOOO"),
        TestElement("im so tired"),
        TestElement("im so tired2"),
        TestElement("im so tired3"),
        TestElement("im so tired4"),
        TestElement("this is just a really really long title like how does this even exist")
    ])

    private init(openedTabs: [TabBarItemRepresentable] = [], initialTab: TabBarID? = nil) {
        self.openedTabs = disableTabs ? [] : openedTabs
        self.selectedTab = initialTab
    }

    @Published var openedTabs: [TabBarItemRepresentable] {
        didSet {
            if disableTabs && !openedTabs.isEmpty {
                self.openedTabs = []
            }
        }
    }

    @Published var selectedTab: TabBarID?

    func selectedTabItem() -> TabBarItemRepresentable? {
        return tabForID(id: selectedTab)
    }

    func tabForID(id: TabBarID?) -> TabBarItemRepresentable? {
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

    public func openTab(tab: TabBarItemRepresentable, from origin: TabBarItemRepresentable? = nil, focus: Bool = true) {
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
