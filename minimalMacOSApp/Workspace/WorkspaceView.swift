//
//  WorkspaceView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import SwiftUI

struct WorkspaceView: View {

    @StateObject
    var tabManager: TabManager = .shared

    var body: some View {
        ZStack {
            if let tabID = tabManager.selectedTab {
                switch tabID {
                case .test(let string):
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            Text("Test: \(string)")
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
            if tabManager.openedTabs.count > 0 && !disableTabs {
                VStack(spacing: 0) {
                    TabBarViewRepresentable(tabManager: .shared)
                        .frame(height: tabBarViewHeight)
                    Divider().foregroundColor(.secondary)
                }
            }
        }
    }
}

struct WorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceView()
    }
}
