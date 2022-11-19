//
//  TabManager.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

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
        TestElement("im so tired5")
    ])

    private init(openedTabs: [TabBarItemRepresentable] = [], initialTab: TabBarItemID? = nil) {
        self.openedTabs = openedTabs
        self.selectedTab = initialTab
    }

    @Published private(set) var openedTabs: [TabBarItemRepresentable] {
        didSet {
            openedTabIDs = openedTabs.map({ $0.tabID })
        }
    }
    @Published private(set) var openedTabIDs: [TabBarItemID] = []

    @Published var selectedTab: TabBarItemID?
    var selectedTabItem: TabBarItemRepresentable? {
        get { tabForID(id: selectedTab) }
        set { selectedTab = newValue?.tabID }
    }

    func tabForID(id: TabBarItemID?) -> TabBarItemRepresentable? {
        guard let id else { return nil }

        switch id {
        case .test(_):
            return openedTabs.first(where: { $0.tabID == id })
        }
    }

    public func closeTab(id: TabBarItemID?, removeAllOccurences: Bool = true) {
        guard let id else { return }

        if removeAllOccurences {
            openedTabs.removeAll(where: { $0.tabID == id })
        } else if let index = openedTabs.firstIndex(where: { $0.tabID == id }) {
            openedTabs.remove(at: index)
        }

        if id == selectedTab {
            selectedTab = nil
        }
    }

    public func openTab(tab: TabBarItemRepresentable, from origin: TabBarItemRepresentable? = nil, focus: Bool = true) {
        if let origin, let originIndex = openedTabs.firstIndex(where: { $0.tabID == origin.tabID }) {
            openedTabs.insert(tab, at: originIndex+1)
        } else {
            openedTabs.append(tab)
        }

        if focus {
            selectedTab = tab.tabID
        }
    }
}
