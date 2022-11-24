//
//  TabBarItemRepresentable.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

/// Protocol for data passed to TabBarItem to conform to
public protocol TabBarItemRepresentable {
    /// Unique tab identifier
    var tabID: TabBarID { get }
    /// String to be shown as tab's title
    var title: String { get }
    /// Image to be shown as tab's icon
    var icon: NSImage { get }
    /// Color of the tab's icon
    var iconColor: Color { get }
}
