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
open class OutlineViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

    var scrollView: NSScrollView!
    public var outlineView: NSOutlineView!

    /// Gets the folder structure
    ///
    /// Also creates a top level item "root" which represents the projects root directory and automatically expands it.
    var content: [OutlineElement] = []

    open func loadContent() -> [OutlineElement] {
        fatalError("Please override this function")
    }

    open func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        fatalError("Please override this function")
    }

    var iconColor: NSColor = .controlAccentColor

    /// Setup the ``scrollView`` and ``outlineView``
    open override func loadView() {
        self.content = loadContent()

        self.scrollView = NSScrollView()
        self.view = scrollView

        self.outlineView = NSOutlineView()
        outlineView.dataSource = self
        outlineView.delegate = self
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

extension OutlineViewController {

    /// Reveals the given item in the outline view by expanding all the parent directories of the file.
    /// - Parameter item: The item to reveal
    func expandParent(item: OutlineElement) {
        self.outlineView.expandItem(item)
        if let parent = outlineView.parent(forItem: item) as? OutlineElement {
            expandParent(item: parent)
        }
    }

    open func outlineViewSelectionDidChange(_ notification: Notification) {
        // for the dev to override
    }

    open func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item as? OutlineElement else { return content.count }
        return item.children.count
    }

    open func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item as? OutlineElement else { return content[index] }
        return item.children[index]
    }

    open func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? OutlineElement else { return false }
        return item.expandable
    }

    open func outlineView(_ outlineView: NSOutlineView,
                     shouldShowCellExpansionFor tableColumn: NSTableColumn?, item: Any) -> Bool {
        true
    }

    open func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        true
    }

    open func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        defaultRowHeight // This can be changed to 20 to match Xcode's row height.
    }
}

public protocol OutlineElement {
    var children: [OutlineElement] { get set }
    var expandable: Bool { get set }
}
