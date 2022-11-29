//
//  TabBarProtocol.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

public protocol TabBarProtocol {
    func minimumTabWidth() -> CGFloat?
    func tabBecomesSmall() -> CGFloat?
    func maximumTabWidth() -> CGFloat?
    func animationDuration() -> CGFloat?
    func configWindow(_ window: NSWindow) -> Void
    func toolbarStyle() -> NSWindow.ToolbarStyle?
    func disableTabs() -> Bool?
}

extension TabBarProtocol {
    var minimumTabWidth: CGFloat { minimumTabWidth() ?? 60 }
    var tabBecomesSmall: CGFloat { tabBecomesSmall() ?? 60 }
    var maximumTabWidth: CGFloat { maximumTabWidth() ?? 120 }
    var animationDuration: CGFloat { animationDuration() ?? 0.3 }
    var toolbarStyle: NSWindow.ToolbarStyle { toolbarStyle() ?? .unifiedCompact }
    var disableTabs: Bool { disableTabs() ?? false }
}

class DefaultTabBarProtocol: TabBarProtocol {
    func minimumTabWidth() -> CGFloat? { 60 }
    func tabBecomesSmall() -> CGFloat? { 60 }
    func maximumTabWidth() -> CGFloat? { 120 }
    func animationDuration() -> CGFloat? { 0.3 }
    func tabBarViewHeight() -> CGFloat? { 28 }
    func configWindow(_ window: NSWindow) {
        window.titleVisibility = .hidden
        window.toolbarStyle = .unifiedCompact
        window.titlebarAppearsTransparent = false
        window.titlebarSeparatorStyle = .automatic
    }
    func toolbarStyle() -> NSWindow.ToolbarStyle? { .unifiedCompact }
    func disableTabs() -> Bool? { false }
}
