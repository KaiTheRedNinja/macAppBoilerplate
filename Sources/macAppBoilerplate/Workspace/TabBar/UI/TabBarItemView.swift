//
//  TabBarItemView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import Cocoa

/// A view for a singular tab
class TabBarItemView: NSView {

    /// The TabBarItemRepresentable that this tab is for
    var tabRepresentable: TabBarItemRepresentable!
    /// The parent tab bar view
    var tabBarView: TabBarView!
    /// The tab manager
    var tabManager: TabManager!
    /// If the tab is alive or not
    var isAlive: Bool = true

    var icon: NSImage
    var iconView: NSButton
    var textView: NSTextField

    // the vertical lines on the left and right of the view
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
        // add the gesture recognisers
        self.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(focusTab)))
        self.addGestureRecognizer(NSMagnificationGestureRecognizer(target: self, action: #selector(didZoom(_:))))
        self.addGestureRecognizer(NSPanGestureRecognizer(target: self, action: #selector(didPan(_:))))

        // configure the icon view
        iconView.isBordered = false
        iconView.bezelStyle = .regularSquare
        iconView.target = self
        iconView.action = #selector(closeTab)
        iconView.wantsLayer = true
        addSubview(iconView)

        // configure the text view
        textView.drawsBackground = false
        textView.isBezeled = false
        textView.cell?.lineBreakMode = .byTruncatingTail
        textView.isEditable = false
        addSubview(textView)

        // add the dividers as subviews
        addSubview(leftDivider)
        addSubview(rightDivider)

        // update and size everything appropriately
        updateIconAndLabel()
        resizeSubviews(withOldSize: .zero)
    }

    func manageDividers(animate: Bool = true) {
        // set the frames of the left and right dividers
        leftDivider.frame = NSRect(x: 0, y: 8, width: 1, height: tabManager.dataSource.tabBarViewHeight-16)
        leftDivider.wantsLayer = true
        leftDivider.layer?.backgroundColor = NSColor.gray.cgColor
        rightDivider.frame = NSRect(x: frame.width-1, y: 8, width: 1, height: tabManager.dataSource.tabBarViewHeight-16)
        rightDivider.wantsLayer = true
        rightDivider.layer?.backgroundColor = NSColor.gray.cgColor

        // create the variables that manage the alpha values and default them to 1 (100% visible)
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
            // animate the dividers opacity changing
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = tabManager.dataSource.animationDuration
                leftDivider.animator().alphaValue = leftAlphaValue
                rightDivider.animator().alphaValue = rightAlphaValue
            })
        } else {
            // do not animate the dividers opacity changing and just do it instantly
            leftDivider.alphaValue = leftAlphaValue
            rightDivider.alphaValue = rightAlphaValue
        }
    }

    /// Updates the icon and label to the tab representable's
    func updateIconAndLabel() {
        // short circuit if isAlive is false, to avoid possible errors
        guard isAlive else { return }

        self.icon = tabRepresentable.icon
        self.iconView.image = icon
        self.textView.stringValue = tabRepresentable.title
        self.textView.textColor = .textColor
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        // short circuit if isAlive is false, to avoid possible errors
        guard isAlive else { return }

        // the text won't show if the tab is in compact mode, but to make animation
        // easier on show/hide, the frame is set anyway
        let newTextViewFrame = CGRect(x: frame.height-2, y: 0,
                                      width: frame.width-frame.height, height: frame.height-7)
        var newTextAlphaValue: CGFloat = 1      // default value is 1         \
        var newIconViewFrame: CGRect = .zero    // default to .zero           |-- all will be changed eventually
        var tabIsInExpandedMode: Bool = true    // defaults to expanded mode  /

        // if the tab is in expanded mode
        if frame.width > tabManager.dataSource.tabBecomesSmall {
            tabIsInExpandedMode = true
            newIconViewFrame = CGRect(x: 4, y: 4, width: self.frame.height-8, height: self.frame.height-8)
            newTextAlphaValue = 1

            // if the tab is in compact mode
        } else {
            tabIsInExpandedMode = false
            newIconViewFrame = CGRect(x: (self.frame.width - (self.frame.height-8))/2, y: 4,
                                      width: self.frame.height-8, height: self.frame.height-8)
            newTextAlphaValue = 0
        }

        // if the frame just only got expanded/contracted from compact/expanded mode, animate the changes
        let oldSizeIsInExpandedMode = oldSize.width > tabManager.dataSource.tabBecomesSmall
        if oldSizeIsInExpandedMode != tabIsInExpandedMode {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = tabManager.dataSource.animationDuration
                textView.animator().frame = newTextViewFrame
                iconView.animator().frame = newIconViewFrame
                textView.animator().alphaValue = newTextAlphaValue
                self.updateTrackingAreas()
                manageDividers()
            } completionHandler: {
                // In case the position the iconView should be at has changed, just set it when the animation has ended.
                let tabStillInExpandedMode = self.frame.width > self.tabManager.dataSource.tabBecomesSmall
                if tabStillInExpandedMode == tabIsInExpandedMode {
                    self.iconView.frame = newIconViewFrame
                }
                self.updateTrackingAreas()
                self.manageDividers()
            }
        } else { // no animation needed
            textView.frame = newTextViewFrame
            iconView.frame = newIconViewFrame
            textView.alphaValue = newTextAlphaValue
        }
        updateTrackingAreas()
        manageDividers()
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

    /// Update the tracking areas to the frame
    override func updateTrackingAreas() {
        mouseHovering = false
        removeTrackingArea(area)
        area = makeTrackingArea()
        addTrackingArea(area)
    }

    /// Create a tracking area the size of the icon view
    private func makeTrackingArea() -> NSTrackingArea {
        return NSTrackingArea(rect: iconView.frame,
                              options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
    }

    /// If the mouse entered, mouseHovering is true
    override func mouseEntered(with event: NSEvent) { mouseHovering = true }

    /// If the mouse exited, mouseHovering is false
    override func mouseExited(with event: NSEvent) { mouseHovering = false }

    // MARK: Gestures
    /// Closes the tab via TabManager
    @objc
    func closeTab() {
        tabManager.closeTab(id: tabRepresentable.tabID)
    }

    /// Closes the tab via TabManager if mouse hovering, else just selects it
    @objc
    func focusTab() {
        guard !mouseHovering else {
            closeTab()
            return
        }

        tabManager.openTab(tab: tabRepresentable)
    }

    /// The amount that the tab bar item is zoomed
    var zoomAmount: CGFloat = 0

    /// Processes zoom gestures
    @objc
    func didZoom(_ sender: NSMagnificationGestureRecognizer?) {
        guard let gesture = sender else { return }
        if gesture.state == .ended {
            // reset zoom amount
            zoomAmount = 0
            tabBarView.sizeTabs(animate: true)
        } else {
            zoomAmount = gesture.magnification
            tabBarView.sizeTabs(animate: false)
        }
    }

    /// flag to indicate if the tab is panning
    var isPanning: Bool = false
    /// the original frame pre-pan
    var originalFrame: NSRect = .zero
    /// the distance that the tab should move
    var clickPointOffset: CGFloat = 0.0
    /// Processes drag gestures
    @objc
    func didPan(_ sender: NSPanGestureRecognizer?) {
        // ensure that the gesture exists and that the gesture's location is in self.superview
        guard let gesture = sender else { return }
        let location = gesture.location(in: self.superview)

        // if the gesture began, setup some variables to keep track of initial state
        if gesture.state == .began {
            isPanning = true
            originalFrame = self.frame
            clickPointOffset = location.x - self.frame.minX

        // if the gesture ended, set isPanning to false. The other variables will be reset the next
        // time the gesture is enacted, so there is no need to set those.
        // focus tab for consistency with Xcode
        } else if gesture.state == .ended {
            isPanning = false
            tabManager.openTab(tab: tabRepresentable)
        }

        // set the location of the tab to be the initial location offset by the offset
        // then order the tabBarView to reposition all the tabs
        frame = NSRect(x: location.x - clickPointOffset, y: 0, width: frame.width, height: frame.height)
        tabBarView.repositionTabs(movingTab: self, state: gesture.state)
    }
}
