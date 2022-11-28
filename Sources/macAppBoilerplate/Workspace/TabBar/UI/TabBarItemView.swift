//
//  TabBarItemView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import Cocoa

class TabBarItemView: NSView {
    var tabRepresentable: TabBarItemRepresentable!
    var tabBarView: TabBarView!
    var tabManager: TabManager = .shared
    var isAlive: Bool = true

    var icon: NSImage
    var iconView: NSButton
    var textView: NSTextField

    var leftDivider = NSView()
    var rightDivider = NSView()

    override init(frame frameRect: NSRect) {
        textView = NSTextField()
        icon = NSImage(systemSymbolName: "circle", accessibilityDescription: nil) ?? NSImage()
        iconView = NSButton()
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("TabBarItemView does not support init from coder")
    }

    func addViews(rect: NSRect) {
        wantsLayer = true
        self.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(focusTab)))
        self.addGestureRecognizer(NSMagnificationGestureRecognizer(target: self, action: #selector(didZoom(_:))))
        self.addGestureRecognizer(NSPanGestureRecognizer(target: self, action: #selector(didPan(_:))))

        iconView.isBordered = false
        iconView.bezelStyle = .regularSquare
        iconView.target = self
        iconView.action = #selector(closeTab)
        iconView.wantsLayer = true
        addSubview(iconView)

        textView.drawsBackground = false
        textView.isBezeled = false
        textView.cell?.lineBreakMode = .byTruncatingTail
        textView.isEditable = false
        addSubview(textView)

        addSubview(leftDivider)
        addSubview(rightDivider)

        updateIconAndLabel()
        resizeSubviews(withOldSize: .zero)
    }

    func manageDividers(animate: Bool = true) {
        leftDivider.frame = NSRect(x: 0, y: 8, width: 1, height: tabBarViewHeight-16)
        leftDivider.wantsLayer = true
        leftDivider.layer?.backgroundColor = NSColor.gray.cgColor

        rightDivider.frame = NSRect(x: frame.width-1, y: 8, width: 1, height: tabBarViewHeight-16)
        rightDivider.wantsLayer = true
        rightDivider.layer?.backgroundColor = NSColor.gray.cgColor

        var leftAlphaValue: CGFloat = 1
        var rightAlphaValue: CGFloat = 1

        // get the location of the tab. If it is the first or last, disable the appropriate divider
        // if the tab is to the left/right of the current tab, then hide the appropriate divider too
        let selectedTabIndex = tabManager.selectedTab == nil ? nil :
        tabManager.openedTabs.firstIndex(where: { $0.tabID.id == tabManager.selectedTab!.id })
        let thisItemTabIndex = tabManager.openedTabs.firstIndex(where: { $0.tabID.id ==  tabRepresentable.tabID.id })
        if thisItemTabIndex == 0 || thisItemTabIndex == (selectedTabIndex ?? -10) + 1 {
            leftAlphaValue = 0
        }
        if thisItemTabIndex == tabManager.openedTabs.count-1 || thisItemTabIndex == (selectedTabIndex ?? -10) - 1 {
            rightAlphaValue = 0
        }

        // if the tab is currently selected or being dragged, disable the dividers
        if thisItemTabIndex == selectedTabIndex || isPanning {
            leftAlphaValue = 0
            rightAlphaValue = 0
        }

        if animate {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = animationDuration
                leftDivider.animator().alphaValue = leftAlphaValue
                rightDivider.animator().alphaValue = rightAlphaValue
            })
        } else {
            leftDivider.alphaValue = leftAlphaValue
            rightDivider.alphaValue = rightAlphaValue
        }
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
                                      width: frame.width-frame.height, height: frame.height-7)

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
        manageDividers()
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

    open override func updateTrackingAreas() {
        mouseHovering = false
        removeTrackingArea(area)
        area = makeTrackingArea()
        addTrackingArea(area)
    }

    private func makeTrackingArea() -> NSTrackingArea {
        return NSTrackingArea(rect: iconView.frame,
                              options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
    }

    open override func mouseEntered(with event: NSEvent) {
        mouseHovering = true
    }

    open override func mouseExited(with event: NSEvent) {
        mouseHovering = false
    }

    // MARK: Gestures
    @objc
    func closeTab() {
        tabManager.closeTab(id: tabRepresentable.tabID)
    }

    @objc
    func focusTab() {
        guard !mouseHovering else {
            closeTab()
            return
        }

        tabManager.selectedTab = tabRepresentable.tabID
    }

    var zoomAmount: CGFloat = 0
    @objc
    func didZoom(_ sender: NSMagnificationGestureRecognizer?) {
        guard let gesture = sender else { return }
        if gesture.state == .ended {
            zoomAmount = 0
            tabBarView.sizeTabs(animate: true)
        } else {
            zoomAmount = gesture.magnification
            tabBarView.sizeTabs(animate: false)
        }
    }

    var isPanning: Bool = false         // flag to indicate if the tab is panning
    var originalFrame: NSRect = .zero   // the original frame pre-pan
    var clickPointOffset: CGFloat = 0.0 // the distance that the tab should move
    @objc
    func didPan(_ sender: NSPanGestureRecognizer?) {
        guard let gesture = sender else { return }
        let location = gesture.location(in: self.superview)
        if gesture.state == .began {
            isPanning = true
            originalFrame = self.frame
            clickPointOffset = location.x - self.frame.minX
        } else if gesture.state == .ended {
            isPanning = false
        }
        frame = NSRect(x: location.x - clickPointOffset, y: 0, width: frame.width, height: frame.height)
        tabBarView.repositionTabs(movingTab: self, state: gesture.state)
    }
}
