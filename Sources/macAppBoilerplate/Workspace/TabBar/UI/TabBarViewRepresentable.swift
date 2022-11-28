//
//  TabBarViewRepresentable.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import SwiftUI

/// Wraps a ``TabBarView`` via `NSViewRepresentable`
struct TabBarViewRepresentable: NSViewRepresentable {

    @EnvironmentObject var tabManager: TabManager

    func makeNSView(context: Context) -> TabBarView {
        let tabView = TabBarView()
        tabView.tabManager = self.tabManager
        tabView.updateTabs()
        return tabView
    }

    func updateNSView(_ nsView: TabBarView, context: Context) {
        nsView.updateTabs()
    }

    typealias NSViewType = TabBarView
}
