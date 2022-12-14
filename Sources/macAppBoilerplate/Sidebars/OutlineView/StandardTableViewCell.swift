//
//  StandardTableViewCell.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

/// A reusable Table View Cell with a label, secondary label, and icon
open class StandardTableViewCell: NSTableCellView {

    /// The main text to display
    public weak var label: NSTextField!
    /// The secondary label, either directly after ``label`` or at the very end of the cell
    public weak var secondaryLabel: NSTextField!
    /// The icon, at the leading edge of the cell
    public weak var icon: NSImageView!

    /// Determines if the ``secondaryLabel`` is at the trailing edge of the cell (true) or directly after ``label`` (false)
    public var secondaryLabelRightAligned: Bool = true {
        didSet {
            resizeSubviews(withOldSize: .zero)
        }
    }

    /// Initializes the `TableViewCell` with an `icon` and `label`
    /// Both the icon and label will be colored, and sized based on the user's preferences.
    /// - Parameters:
    ///   - frameRect: The frame of the cell.
    ///   - item: The file item the cell represents.
    ///   - isEditable: Set to true if the user should be able to edit the file name.
    public init(frame frameRect: NSRect, isEditable: Bool = true) {
        super.init(frame: frameRect)
        setupViews(frame: frameRect, isEditable: isEditable)
    }

    /// Default init, assumes isEditable to be false
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews(frame: frameRect, isEditable: false)
    }

    private func setupViews(frame frameRect: NSRect, isEditable: Bool) {
        // Create the label
        let label = createLabel()
        self.label = label
        configLabel(label: self.label, isEditable: isEditable)
        self.textField = label

        // Create the secondary label
        let secondaryLabel = createSecondaryLabel()
        self.secondaryLabel = secondaryLabel
        configSecondaryLabel(secondaryLabel: secondaryLabel)

        // Create the icon
        let icon = createIcon()
        self.icon = icon
        configIcon(icon: icon)
        imageView = icon

        // add constraints
        createConstraints(frame: frameRect)
        addSubview(label)
        addSubview(secondaryLabel)
        addSubview(icon)
    }

    // MARK: Create and config stuff
    /// Creates the label
    open func createLabel() -> NSTextField {
        return SpecialSelectTextField(frame: .zero)
    }

    /// Sets up a given label with a given editability
    open func configLabel(label: NSTextField, isEditable: Bool) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.drawsBackground = false
        label.isBordered = false
        label.isEditable = isEditable
        label.isSelectable = isEditable
        label.layer?.cornerRadius = 10.0
        label.font = .labelFont(ofSize: fontSize)
        label.lineBreakMode = .byTruncatingMiddle
    }

    /// Creates the secondary label
    open func createSecondaryLabel() -> NSTextField {
        return NSTextField(frame: .zero)
    }

    /// Sets up a given secondary label with a given editability
    open func configSecondaryLabel(secondaryLabel: NSTextField) {
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.drawsBackground = false
        secondaryLabel.isBordered = false
        secondaryLabel.isEditable = false
        secondaryLabel.isSelectable = false
        secondaryLabel.layer?.cornerRadius = 10.0
        secondaryLabel.font = .systemFont(ofSize: fontSize)
        secondaryLabel.alignment = .center
        secondaryLabel.textColor = NSColor(Color.secondary)
    }

    /// Creates the image view
    open func createIcon() -> NSImageView {
        return NSImageView(frame: .zero)
    }

    /// Sets up a given image view
    open func configIcon(icon: NSImageView) {
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.symbolConfiguration = .init(pointSize: fontSize, weight: .regular, scale: .medium)
    }

    /// Contrains the views. Currently only redirects to ``resizeSubviews(withOldSize:)``
    open func createConstraints(frame frameRect: NSRect) {
        resizeSubviews(withOldSize: .zero)
    }

    let iconWidth: CGFloat = 22

    /// Positions all the views
    open override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)

        icon.frame = NSRect(x: 2, y: 4,
                            width: iconWidth, height: frame.height)
        // center align the image
        if let alignmentRect = icon.image?.alignmentRect {
            icon.frame = NSRect(x: (iconWidth+4-alignmentRect.width)/2, y: 4,
                                width: alignmentRect.width, height: frame.height)
        }

        var secondaryLabelWidth = secondaryLabel.frame.width
        var secondaryLabelMinX = secondaryLabel.frame.minX
        var labelWidth = label.frame.width
        var labelMinX = label.frame.minX

        // right align the secondary label
        if secondaryLabelRightAligned {
            secondaryLabel.sizeToFit()
            secondaryLabelWidth = secondaryLabel.frame.width
            secondaryLabelMinX = frame.width-secondaryLabelWidth
            labelWidth = secondaryLabelMinX-icon.frame.maxX-5
            labelMinX = iconWidth + 2

        // put the secondary label right after the primary label
        } else {
            label.sizeToFit()
            labelWidth = label.frame.width
            labelMinX = iconWidth + 2
            secondaryLabelWidth = secondaryLabel.frame.width
            secondaryLabelMinX = frame.width - labelMinX - labelWidth - 2
        }

        label.frame = NSRect(x: labelMinX,
                             y: 2.8,
                             width: labelWidth,
                             height: 22)
        secondaryLabel.frame = NSRect(x: secondaryLabelMinX,
                                      y: 2.8,
                                      width: secondaryLabelWidth,
                                      height: 22)
    }

    /// *Not Implemented*
    public required init?(coder: NSCoder) {
        fatalError("""
            init?(coder: NSCoder) isn't implemented on `StandardTableViewCell`.
            Please use `.init(frame: NSRect, isEditable: Bool)
            """)
    }

    /// Returns the font size for the current row height. Defaults to `13.0`
    private var fontSize: Double {
        switch self.frame.height {
        case 20: return 11
        case 22: return 13
        case 24: return 14
        default: return 13
        }
    }

    class SpecialSelectTextField: NSTextField {
        //        override func becomeFirstResponder() -> Bool {
        // TODO: Set text range
        // this is the code to get the text range, however I cannot find a way to select it :(
        //            NSRange(location: 0, length: stringValue.distance(from: stringValue.startIndex,
        //                to: stringValue.lastIndex(of: ".") ?? stringValue.endIndex))
        //            return true
        //        }
    }
}
