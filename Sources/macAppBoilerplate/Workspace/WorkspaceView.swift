//
//  WorkspaceView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import SwiftUI

/// The main workspace content
struct WorkspaceView<Content: View>: View {

    @ObservedObject
    var tabManager: TabManager

    init(tabManager: TabManager, @ViewBuilder viewForTab: @escaping (TabBarID) -> Content) {
        self.tabManager = tabManager
        self.viewForTab = viewForTab
    }

    var viewForTab: (TabBarID) -> Content

    var body: some View {
        ZStack {
            if let tabID = tabManager.selectedTab {
                self.viewForTab(tabID)
            } else {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("No Tab")
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background {
            EffectView(
                NSVisualEffectView.Material.contentBackground,
                blendingMode: NSVisualEffectView.BlendingMode.withinWindow
            )
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            if tabManager.openedTabs.count > 0 && !tabManager.dataSource.disableTabs {
                VStack(spacing: 0) {
                    TabBarViewRepresentable(tabManager: tabManager)
                        .frame(height: tabManager.dataSource.tabBarViewHeight)
                    Divider().foregroundColor(.secondary)
                }
            }
        }
    }
}

struct WorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceView(tabManager: TabManager.default, viewForTab: { _ in Text("HIII") })
    }
}
