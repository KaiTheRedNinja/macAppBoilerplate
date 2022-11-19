//
//  TabManager.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

class TabManager: ObservableObject {
    static let shared: TabManager = .init()

    @Published var openedTabs: [TabBarItemID] = [
        .test("hi"),
        .test("TEST"),
        .test("BOOO"),
        .test("HELLOOOO"),
        .test("im so tired")
    ]
    @Published var selectedTab: TabBarItemID?

    @Published var selectedTabItem: TabBarItemRepresentable? = TestTabBarItem(id: "hi")

    func tabForID(id: TabBarItemID) -> TabBarItemRepresentable? {
        switch id {
        case .test(_):
            return TestTabBarItem.items.first(where: { $0.tabID == id })
        }
    }
}

class TestTabBarItem: TabBarItemRepresentable {

    static let items = [
        TestTabBarItem(id: "hi"),
        TestTabBarItem(id: "TEST"),
        TestTabBarItem(id: "BOOO"),
        TestTabBarItem(id: "HELLOOOO"),
        TestTabBarItem(id: "im so tired")
    ]

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

