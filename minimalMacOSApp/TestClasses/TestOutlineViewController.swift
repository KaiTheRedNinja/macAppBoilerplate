//
//  TestOutlineViewController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

class TestOutlineViewController: OutlineViewController {

    override func loadContent() -> [OutlineElement] {
        print("Loading content")
        return [
            TestElement("HI", children: [
                TestElement("BYE", children: []),
                TestElement("wow", children: [])
            ])
        ]
    }

    override func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        print("View requested for \(item)")
        guard let tableColumn, let item = item as? TestElement else { return nil }
        let frameRect = NSRect(x: 0, y: 0, width: tableColumn.width, height: defaultRowHeight)
        let view = TestTableViewCell(frame: frameRect)

        view.item = item
        view.configIcon(icon: view.icon)
        view.configLabel(label: view.label, isEditable: view.label.isEditable)

        return view
    }

    override func outlineViewSelectionDidChange(_ notification: Notification) {
        print("Selection changed")

        let selectedIndex = outlineView.selectedRow
        guard selectedIndex >= 0,
                let selectedItem = outlineView.item(atRow: selectedIndex) as? TestElement
        else { return }

        withAnimation(
            .easeOut( duration: 0.20 )
        ) {
            TabManager.shared.openTab(tab: selectedItem)
        }
    }
}

class TestElement: OutlineElement, TabBarItemRepresentable {

    // MARK: TabBarItemRepresentable
    var tabID: TabBarID
    var title: String
    var icon: NSImage
    var iconColor: Color

    // MARK: OutlineElement
    var children: [OutlineElement] {
        didSet {
            expandable = !children.isEmpty
        }
    }
    var expandable: Bool

    var text: String

    init(_ text: String, children: [TestElement] = []) {
        self.text = text
        self.children = children
        self.expandable = !children.isEmpty

        self.tabID = TestTabBarID.test(text)
        self.title = text
        self.icon = NSImage(systemSymbolName: "circle", accessibilityDescription: nil)!
        self.iconColor = .accentColor
    }
}
