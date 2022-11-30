//
//  OutlineViewController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

public let defaultRowHeight: Double = 22

/// A `NSViewController` that handles the **ProjectNavigator** in the **NavigatorSideabr**.
///
/// Adds a ``outlineView`` inside a ``scrollView`` which shows the folder structure of the
/// currently open project.
open class OutlineViewController: NSViewController {

    var scrollView: NSScrollView!
    public var outlineView: NSOutlineView!
    public var tabManager: TabManager!

    var iconColor: NSColor = .controlAccentColor

    /// Setup the ``scrollView`` and ``outlineView``
    open override func loadView() {
        self.scrollView = NSScrollView()
        self.view = scrollView

        self.outlineView = NSOutlineView()
        outlineView.autosaveExpandedItems = true
        outlineView.headerView = nil
        //        outlineView.menu = ProjectNavigatorMenu(sender: self.outlineView, workspaceURL: (workspace?.fileURL)!)
        //        outlineView.menu?.delegate = self

        let column = NSTableColumn(identifier: .init(rawValue: "Cell"))
        column.title = "Cell"
        outlineView.addTableColumn(column)

        scrollView.documentView = outlineView
        scrollView.contentView.automaticallyAdjustsContentInsets = false
        scrollView.contentView.contentInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        scrollView.scrollerStyle = .overlay
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        outlineView.rowHeight = defaultRowHeight
        outlineView.reloadData()

        outlineView.expandItem(outlineView.item(atRow: 0))
    }
}

// for the dev to override
extension OutlineViewController {

    /// Reveals the given item in the outline view by expanding all the parent directories of the file.
    /// - Parameter item: The item to reveal
    public func expandParent(item: OutlineElement) {
        self.outlineView.expandItem(item)
        if let parent = outlineView.parent(forItem: item) as? OutlineElement {
            expandParent(item: parent)
        }
    }
}

public protocol OutlineElement {
    var expandable: Bool { get set }
}
