//
//  TabBarViewRepresentable.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import SwiftUI

struct TabBarViewRepresentable: NSViewRepresentable {

    @ObservedObject var tabManager: TabManager

    func makeNSView(context: Context) -> TabBarView {
        let tabView = TabBarView()
        tabView.tabManager = .shared
        tabView.updateTabs()
        return tabView
    }

    func updateNSView(_ nsView: TabBarView, context: Context) {
        nsView.updateTabs()
    }

    typealias NSViewType = TabBarView
}
