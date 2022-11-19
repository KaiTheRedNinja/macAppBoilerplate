//
//  TestTableViewCell.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

class TestTableViewCell: StandardTableViewCell {

    var item: TestElement?

    override func configIcon(icon: NSImageView) {
        super.configIcon(icon: icon)
        icon.image = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: nil)
    }

    override func configLabel(label: NSTextField, isEditable: Bool) {
        super.configLabel(label: label, isEditable: isEditable)
        label.stringValue = item?.text ?? "No Text"
    }
}
