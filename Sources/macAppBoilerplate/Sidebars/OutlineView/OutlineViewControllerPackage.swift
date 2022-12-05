//
//  File.swift
//  
//
//  Created by Kai Quan Tay on 30/11/22.
//

import SwiftUI

/// A `NSViewController` that handles the **ProjectNavigator** in the **NavigatorSideabr**.
///
/// Adds a ``outlineView`` inside a ``scrollView`` which shows the folder structure of the
/// currently open project.
/// Includes built-in conformance to NSOutlineViewDelegate and NSOutlineViewDataSource.
open class OutlineViewControllerPackage: OutlineViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

    public var content: [OutlineElement] = []

    // Loading content
    open func loadContent() -> [OutlineElement] {
        fatalError("Please override this function")
    }

    // Providing a view for a given item in a column
    open func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        fatalError("Please override this function")
    }

    // The number of children an item has
    open func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard item is OutlineElement else { return content.count }
        fatalError("Please override this function")
    }

    // The child at an index of an item
    open func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard item is OutlineElement else { return content[index] }
        fatalError("Please override this function")
    }

    /// Setup the ``scrollView`` and ``outlineView``
    open override func loadView() {
        super.loadView()

        self.outlineView.dataSource = self
        self.outlineView.delegate = self
    }
}

// for the dev to override
extension OutlineViewControllerPackage {
    open func outlineViewSelectionDidChange(_ notification: Notification) {
        // for the dev to override
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

// for the dev to override
public extension OutlineViewControllerPackage {

    /// Reveals the given item in the outline view by expanding all the parent directories of the file.
    /// - Parameter item: The item to reveal
    func expandParent(item: OutlineElement) {
        self.outlineView.expandItem(item)
        if let parent = outlineView.parent(forItem: item) as? OutlineElement {
            expandParent(item: parent)
        }
    }
}

/// Defines if an item is automatically expandable or not
public protocol OutlineElement {
    var expandable: Bool { get set }
}

