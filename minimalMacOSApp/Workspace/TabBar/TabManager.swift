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
        TestTabBarItem(id: "hi"),
        TestTabBarItem(id: "TEST"),
        TestTabBarItem(id: "BOOO"),
        TestTabBarItem(id: "HELLOOOO"),
        TestTabBarItem(id: "im so tired"),
        TestTabBarItem(id: "im so tired2"),
        TestTabBarItem(id: "im so tired3"),
        TestTabBarItem(id: "im so tired4"),
        TestTabBarItem(id: "im so tired5")
    ])

    private init(openedTabs: [TabBarItemRepresentable] = [], initialTab: TabBarItemID? = nil) {
        self.openedTabs = openedTabs
        self.selectedTab = initialTab
    }

    @Published var openedTabs: [TabBarItemRepresentable] {
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

    func closeTab(id: TabBarItemID?, removeAllOccurences: Bool = true) {
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
}

class TestTabBarItem: TabBarItemRepresentable {

    var tabID: TabBarItemID
    var title: String
    var icon: Image
    var iconColor: Color

    init(id: String) {
        self.tabID = .test(id)
        self.title = id
        self.icon = Image(systemName: "circle")
        self.iconColor = .accentColor
    }
}

