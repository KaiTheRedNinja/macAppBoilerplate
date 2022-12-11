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

    public var scrollView: NSScrollView!
    public var outlineView: NSOutlineView!
    public var tabManager: TabManager!

    var iconColor: NSColor = .controlAccentColor

    /// Setup the ``scrollView`` and ``outlineView``
    open override func loadView() {
        // create the scrollview and set the scroll view as this view controller's view
        self.scrollView = NSScrollView()
        self.view = scrollView

        // create an outlineview without a header
        self.outlineView = NSOutlineView()
        outlineView.headerView = nil

        // TODO: Add right click menu delegate

        // Add a single column for the one column of content.
        // The name of this column will never be shown.
        let column = NSTableColumn(identifier: .init(rawValue: "Cell"))
        column.title = "Cell"
        outlineView.addTableColumn(column)

        // Embed the outlineView in the scrollView, and make sure that the
        // outlineView stays clipped within the scrollView
        scrollView.documentView = outlineView
        scrollView.contentView.automaticallyAdjustsContentInsets = false
        scrollView.contentView.contentInsets = .init(top: 10, left: 0, bottom: 0, right: 0)

        // set the scrollView to only scroll vertically and to hide the scrollers automatically
        scrollView.scrollerStyle = .overlay
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        outlineView.rowHeight = defaultRowHeight

        // load the data and expand the first item
        outlineView.reloadData()
        outlineView.expandItem(outlineView.item(atRow: 0))
    }
}
