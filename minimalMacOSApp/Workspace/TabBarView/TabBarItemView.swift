//
//  TabBarItemView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import Cocoa

class TabBarItemView: NSView {
    var tabRepresentable: TabBarItemRepresentable!
    var isAlive: Bool = true

    var icon: NSImage
    var iconView: NSButton
    var textView: NSTextField

    override init(frame frameRect: NSRect) {
        textView = NSTextField()
        icon = NSImage(systemSymbolName: "circle", accessibilityDescription: nil) ?? NSImage()
        iconView = NSButton()
        super.init(frame: frameRect)
    }

    @objc
    func closeTab() {
    }

    required init?(coder: NSCoder) {
        fatalError("TabBarItemView does not support init from coder")
    }

    func addViews(rect: NSRect) {
        iconView.isBordered = false
        iconView.bezelStyle = .regularSquare
        iconView.target = self
        iconView.action = #selector(closeTab)
        iconView.wantsLayer = true
        iconView.layer?.borderColor = .white
        iconView.layer?.borderWidth = 1
        addSubview(iconView)

        textView.drawsBackground = false
        textView.isBezeled = false
        textView.cell?.lineBreakMode = .byTruncatingTail
        textView.isEditable = false
        addSubview(textView)

        wantsLayer = true
        layer?.borderWidth = 1
        layer?.borderColor = .white

        updateIconAndLabel()
        resizeSubviews(withOldSize: .zero)
    }

    func updateIconAndLabel() {
        // short circuit if isAlive is false, to avoid possible errors
        guard isAlive else { return }

        self.icon = tabRepresentable.icon
        self.iconView.image = icon
        self.textView.stringValue = tabRepresentable.title
        self.textView.textColor = .white
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        // short circuit if isAlive is false, to avoid possible errors
        guard isAlive else { return }

        // the text won't show if the tab is in compact mode, but to make animation
        // easier on show/hide, the frame is set anyway
        let newTextViewFrame = CGRect(x: frame.height-2, y: 0,
                                      width: frame.width-frame.height+8-4, height: frame.height-7)

        // if the tab is in expanded mode
        if frame.width > tabBecomesSmall {
            // if the frame just only got expanded from compact mode, animate the changes
            if oldSize.width <= tabBecomesSmall {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = animationDuration

                    iconView.animator().frame = CGRect(x: 4, y: 4, width: self.frame.height-8, height: self.frame.height-8)
                    textView.animator().frame = newTextViewFrame
                    textView.animator().alphaValue = 1
                }) {
                    // In case the position the iconView should be at has changed, just set it when the animation has ended.
                    if self.frame.width > tabBecomesSmall {
                        self.iconView.frame = CGRect(x: 4, y: 4, width: self.frame.height-8, height: self.frame.height-8)
                    }
                    self.updateTrackingAreas()
                }
            } else { // no animation needed
                textView.alphaValue = 1
                iconView.frame = CGRect(x: 4, y: 4, width: frame.height-8, height: frame.height-8)
                textView.frame = newTextViewFrame
            }

            // if the tab is in compact mode
        } else {
            // if the frame just only got compacted from expanded mode, animate the changes
            if oldSize.width > tabBecomesSmall {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = animationDuration

                    iconView.animator().frame = CGRect(x: (self.frame.width - (self.frame.height-8))/2, y: 4,
                                                       width: self.frame.height-8, height: self.frame.height-8)
                    textView.animator().alphaValue = 0
                }) {
                    if self.frame.width <= tabBecomesSmall {
                        self.iconView.frame = CGRect(x: (self.frame.width - (self.frame.height-8))/2, y: 4,
                                                    width: self.frame.height-8, height: self.frame.height-8)
                    }
                    self.textView.frame = newTextViewFrame
                    self.updateTrackingAreas()
                }
            } else { // no animation needed
                iconView.frame = CGRect(x: (frame.width - (frame.height-8))/2, y: 4, width: frame.height-8, height: frame.height-8)
                textView.frame = newTextViewFrame
                textView.alphaValue = 0
            }
        }
        updateTrackingAreas()
    }

    // MARK: Mouse hover

    private lazy var area = makeTrackingArea()

    // Used to toggle between the close tab image and the favicon image
    private var mouseHovering = false {
        didSet {
            if mouseHovering {
                iconView.image = NSImage(systemSymbolName: "x.square.fill", accessibilityDescription: nil)!
            } else {
                iconView.image = icon
            }
        }
    }

    public override func updateTrackingAreas() {
        mouseHovering = false
        removeTrackingArea(area)
        area = makeTrackingArea()
        addTrackingArea(area)
    }

    private func makeTrackingArea() -> NSTrackingArea {
        return NSTrackingArea(rect: NSRect(x: 0, y: 0, width: frame.width, height: frame.height),
                              options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
    }

    public override func mouseEntered(with event: NSEvent) {
        mouseHovering = true
    }

    public override func mouseExited(with event: NSEvent) {
        mouseHovering = false
    }
}
