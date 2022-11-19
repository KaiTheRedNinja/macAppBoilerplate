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
        let view = StandardTableViewCell(frame: frameRect)
        view.label.stringValue = item.text

        if let image = NSImage(systemSymbolName: "circle", accessibilityDescription: nil) {
            view.icon = NSImageView(image: image)
        }

        return view
    }
}

class TestElement: OutlineElement {
    var children: [OutlineElement] {
        didSet {
            expandable = !children.isEmpty
        }
    }
    var expandable: Bool

    var text: String

    init(_ text: String, children: [TestElement]) {
        self.text = text
        self.children = children
        self.expandable = !children.isEmpty
    }

    enum Keys: CodingKey {
        case children
        case text
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.children as! [TestElement], forKey: .children)
        try container.encode(self.text, forKey: .text)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.children = try container.decode([TestElement].self, forKey: .children)
        self.expandable = !children.isEmpty
        self.text = try container.decode(String.self, forKey: .text)
    }
}
