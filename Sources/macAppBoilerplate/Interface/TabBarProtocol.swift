//
//  TabBarProtocol.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

public protocol TabBarProtocol {
    func getMinimumTabWidth() -> CGFloat?
    func getTabBecomesSmall() -> CGFloat?
    func getMaximumTabWidth() -> CGFloat?
    func getAnimationDuration() -> CGFloat?
    func getTabBarViewHeight() -> CGFloat?
    func getDisableTabs() -> Bool?

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

class DefaultTabBarProtocol: TabBarProtocol {
}
