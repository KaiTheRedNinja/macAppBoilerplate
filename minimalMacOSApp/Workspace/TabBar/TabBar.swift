//
//  TabBar.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

struct TabBar: View {

    @StateObject
    var tabManager: TabManager = .shared

    @State
    var expectedTabWidth: CGFloat = 0

    @State
    var isHoveringOverTabs: Bool = false

    var body: some View {
        HStack(spacing: 2) {
//            Button {
//            } label: {
//                Image(systemName: "circle")
//            }
//            .buttonStyle(.plain)
//            .padding(.leading, 8)

            GeometryReader { geometryProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { scrollReader in
                        HStack(
                            alignment: .center,
                            spacing: -1
                        ) {
                            ForEach(tabManager.openedTabs, id: \.tabID) { item in
                                TabBarItem(
                                    expectedWidth: $expectedTabWidth,
                                    item: item
                                )
                                .frame(height: 28)
                            }
                        }
                        // This padding is to hide dividers at two ends under the accessory view divider.
                        .padding(.horizontal, -1)
                        .onAppear {
                            // On view appeared, compute the initial expected width for tabs.
                            updateExpectedTabWidth(proxy: geometryProxy)
                            // On first tab appeared, jump to the corresponding position.
                            scrollReader.scrollTo(tabManager.selectedTab)
                        }
                        // When selected tab is changed, scroll to it if possible.
                        .onChange(of: tabManager.selectedTab) { targetId in
                            guard let selectedId = targetId else { return }
                            scrollReader.scrollTo(selectedId)
                        }
                        // When tabs are changing, re-compute the expected tab width.
                        .onChange(of: tabManager.openedTabIDs) { _ in
                            updateForTabCountChange(geometryProxy: geometryProxy)
                        }
                        // When window size changes, re-compute the expected tab width.
                        .onChange(of: geometryProxy.size.width) { _ in
                            updateExpectedTabWidth(proxy: geometryProxy)
                        }
                        // When user is not hovering anymore, re-compute the expected tab width immediately.
                        .onHover { isHovering in
                            isHoveringOverTabs = isHovering
                            if !isHovering {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    updateExpectedTabWidth(proxy: geometryProxy)
                                }
                            }
                        }
                        .frame(height: 28)
                    }
                }
            }
        }
        .frame(height: 29, alignment: .center)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    /// Update the expected tab width when corresponding UI state is updated.
    ///
    /// This function will be called when the number of tabs or the parent size is changed.
    private func updateExpectedTabWidth(proxy: GeometryProxy) {
        expectedTabWidth = max(
            // Equally divided size of a native tab.
            (proxy.size.width + 1) / CGFloat(tabManager.openedTabs.count) + 1,
            // Min size of a native tab.
            CGFloat(140)
        )
        print("Expected tab width: \(expectedTabWidth)")
    }

    /// Conditionally updates the `expectedTabWidth`.
    /// Called when the tab count changes or the temporary tab changes.
    /// - Parameter geometryProxy: The geometry proxy to calculate the new width using.
    private func updateForTabCountChange(geometryProxy: GeometryProxy) {
        // Only update the expected width when user is not hovering over tabs.
        // This should give users a better experience on closing multiple tabs continuously.
        if !isHoveringOverTabs {
            withAnimation(.easeOut(duration: 0.15)) {
                updateExpectedTabWidth(proxy: geometryProxy)
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
