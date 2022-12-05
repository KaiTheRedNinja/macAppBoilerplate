//
//  TabBarProtocol.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

public protocol TabBarProtocol {

    /// The minimum width of a tab. Tabs will not get any smaller (in width) than this value.
    /// See also: ``getMaximumTabWidth()-8et9d``
    func getMinimumTabWidth() -> CGFloat?

    /// The width at which the tab will hide its text and only show its icon.
    func getTabBecomesSmall() -> CGFloat?

    /// The width at which the tab will stop growing. Tabs will not get any larger (in width) than this value.
    /// See also: ``getMinimumTabWidth()-9ng11``
    func getMaximumTabWidth() -> CGFloat?

    /// The duration of animations such as opening, closing, and rearrangement snapping
    func getAnimationDuration() -> CGFloat?

    /// The height of the tab bar
    func getTabBarViewHeight() -> CGFloat?

    /// If tabs should be disabled or not. When tabs are disabled, the tab bar
    /// is hidden and only one tab's contents will be shown at a time. When the tab is closed,
    /// the workspace view will revert to its "No Tab" state.
    func getDisableTabs() -> Bool?

    /// Passes the NSWindow to the delegate for setup
    func configWindow(_ window: NSWindow) -> Void
}

public extension TabBarProtocol {
    // default implementations
    func getMinimumTabWidth() -> CGFloat? { nil }
    func getTabBecomesSmall() -> CGFloat? { nil }
    func getMaximumTabWidth() -> CGFloat? { nil }
    func getAnimationDuration() -> CGFloat? { nil }
    func getTabBarViewHeight() -> CGFloat? { nil }
    func getDisableTabs() -> Bool? { nil }

    func configWindow(_ window: NSWindow) {
        window.titleVisibility = .hidden
        window.toolbarStyle = .unifiedCompact
        window.titlebarAppearsTransparent = false
        window.titlebarSeparatorStyle = .automatic
    }

    // safe access variables
    var minimumTabWidth: CGFloat { getMinimumTabWidth() ?? 60 }
    var tabBecomesSmall: CGFloat { getTabBecomesSmall() ?? 60 }
    var maximumTabWidth: CGFloat { getMaximumTabWidth() ?? 120 }
    var animationDuration: CGFloat { getAnimationDuration() ?? 0.3 }
    var tabBarViewHeight: CGFloat { getTabBarViewHeight() ?? 28 }
    var disableTabs: Bool { getDisableTabs() ?? false }
}

/// An empty implementation of ``TabBarProtocol``, used as the default whenever a protocol is not provided.
class DefaultTabBarProtocol: TabBarProtocol {
}
