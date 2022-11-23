//
//  TabBarView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import Cocoa

let minimumTabWidth: CGFloat = 60
let tabBecomesSmall: CGFloat = 60
let maximumTabWidth: CGFloat = 120
let animationDuration = 0.3

class TabBarView: NSView {
    var scrollView: NSScrollView?
    var tabManager: TabManager!
    var tabViews: [TabBarItemView]

    override init(frame frameRect: NSRect) {
        self.tabViews = []
        super.init(frame: frameRect)
        addScrollView(rect: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("TabBarView does not support init from coder")
    }

    func addScrollView(rect: NSRect) {
        scrollView = NSScrollView(frame: rect)
        scrollView?.documentView = NSView()
        scrollView?.wantsLayer = true
        scrollView?.layer?.cornerRadius = 0
//        scrollView?.drawsBackground = false
//        scrollView?.contentView.drawsBackground = false
        scrollView?.verticalScrollElasticity = .none
        addSubview(scrollView!)
    }

    func updateTabs() {
        print("Updating tabs")
        // iterate over tabs and mark those that don't exist anymore as dead
        for tabView in tabViews {
            if !tabManager.openedTabIDs.contains(tabView.tabRepresentable.tabID) {
                print("Tab Removed: \(tabView.tabRepresentable.tabID)")
                tabView.isAlive = false
            }
        }

        // iterate over tabs and create new ones as needed
        var newTabs = tabViews
        for (index, tab) in tabManager.openedTabs.enumerated() {
            if !tabViews.map({ $0.tabRepresentable.tabID }).contains(tab.tabID) {
                print("Tab added: \(tab.tabID)")
                let newItem = TabBarItemView()
                newItem.tabBarView = self
                newItem.tabRepresentable = tab
                newItem.addViews(rect: .zero)
                if index-1 < newTabs.count && index-1 >= 0 {
                    newItem.frame = NSRect(x: newTabs[index-1].frame.maxX, y: 0, width: 0, height: 30)
                } else {
                    newItem.frame = NSRect(x: 0, y: 0, width: 0, height: 30)
                }
                newItem.resizeSubviews(withOldSize: .zero)
                newTabs.insert(newItem, at: index)
            }
        }
        self.tabViews = newTabs
        sizeTabs()
    }

    func sizeTabs(animate: Bool = true) {
        scrollView?.frame = self.frame
        let widthOfTabView = self.frame.width

        // determine the maximum width of a tab
        let numberOfTabs = tabManager.openedTabs.count
        var idealWidth: CGFloat = minimumTabWidth

        idealWidth = widthOfTabView/CGFloat(numberOfTabs)

        // pin idealWidth between the minimum and maximum tab sizes
        idealWidth = max(minimumTabWidth, min(idealWidth, maximumTabWidth))

        // iterate over the tabs and size them as needed
        var widthSoFar: CGFloat = 0
        for tabView in self.tabViews {
            // make sure that the tab is in the scroll subview
            if tabView.superview != scrollView?.documentView {
                tabView.removeFromSuperview()
                scrollView?.documentView?.addSubview(tabView)
            }

            // if the tab is marked as dead, animate its width to 0 and remove it
            guard tabView.isAlive else {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = animationDuration

                    // change the width to 0
                    tabView.animator().frame = NSRect(x: widthSoFar, y: 0, width: 0, height: 30)

                    // change the opacity
                    tabView.animator().alphaValue = 0.0
                }) {
                    // on completion, remove the tab view
                    tabView.removeFromSuperview()
                    self.tabViews.removeAll(where: { $0.tabRepresentable.tabID == tabView.tabRepresentable.tabID })
                }
                // no need to increment widthSoFar as the tab will have no width
                continue
            }

            // size the tab to the ideal width
            let tabIsFocused = tabManager.selectedTab == tabView.tabRepresentable.tabID
            tabView.manageDividers()

            var newFrame = tabView.frame
            var newColor: CGColor?

            if tabIsFocused {
                // if its focused, size it to be the maximum size
                newFrame = NSRect(x: widthSoFar, y: 0, width: maximumTabWidth * (tabView.zoomAmount + 1), height: 30)
                newColor = NSColor.controlAccentColor.cgColor.copy(alpha: 0.5)
                widthSoFar += maximumTabWidth * (tabView.zoomAmount + 1)
            } else {
                // if it is not focused, size it to be the ideal size
                newFrame = NSRect(x: widthSoFar, y: 0, width: idealWidth * (tabView.zoomAmount + 1), height: 30)
                newColor = nil
                widthSoFar += idealWidth * (tabView.zoomAmount + 1)
            }

            if animate {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = animationDuration
                    tabView.animator().frame = newFrame
                })
            } else {
                tabView.frame = newFrame
            }
            tabView.layer?.backgroundColor = newColor
        }

        // set the document view size
        let newDocSize = NSRect(x: 0, y: 0, width: max(frame.width, widthSoFar), height: 30)
        if animate {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = animationDuration
                scrollView?.documentView?.animator().frame = newDocSize
            })
        } else {
            scrollView?.documentView?.frame = newDocSize
        }
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        sizeTabs(animate: false)
    }
}
