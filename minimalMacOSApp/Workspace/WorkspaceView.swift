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
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Text("Needs Implementation")
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background {
            EffectView(
                NSVisualEffectView.Material.contentBackground,
                blendingMode: NSVisualEffectView.BlendingMode.withinWindow
            )
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            if tabManager.openedTabs.count > 1 {
                VStack(spacing: 0) {
                    TabBar()
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
