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

let tabBarViewHeight: CGFloat = 28

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
        // iterate over tabs and mark those that don't exist anymore as dead
        for tabView in tabViews {
            if !tabManager.openedTabIDs.contains(tabView.tabRepresentable.tabID) {
                tabView.isAlive = false
            }
        }

        // iterate over tabs and create new ones as needed
        var newTabs = tabViews
        for (index, tab) in tabManager.openedTabs.enumerated() {
            if !tabViews.map({ $0.tabRepresentable.tabID }).contains(tab.tabID) {
                let newItem = TabBarItemView()
                newItem.tabBarView = self
                newItem.tabRepresentable = tab
                newItem.addViews(rect: .zero)
                if index-1 < newTabs.count && index-1 >= 0 {
                    newItem.frame = NSRect(x: newTabs[index-1].frame.maxX, y: 0, width: 0, height: tabBarViewHeight)
                } else {
                    newItem.frame = NSRect(x: 0, y: 0, width: 0, height: tabBarViewHeight)
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
                    tabView.animator().frame = NSRect(x: widthSoFar, y: 0, width: 0, height: tabBarViewHeight)

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
                newFrame = NSRect(x: widthSoFar, y: 0, width: maximumTabWidth * (tabView.zoomAmount + 1), height: tabBarViewHeight)
                newColor = NSColor.controlAccentColor.cgColor.copy(alpha: 0.5)
                widthSoFar += maximumTabWidth * (tabView.zoomAmount + 1)
            } else {
                // if it is not focused, size it to be the ideal size
                newFrame = NSRect(x: widthSoFar, y: 0, width: idealWidth * (tabView.zoomAmount + 1), height: tabBarViewHeight)
                newColor = nil
                widthSoFar += idealWidth * (tabView.zoomAmount + 1)
            }

            // if the tab is panning, don't set the x location, the view is handling that itself.
            // if its not the focused tab, make the background gray
            if tabView.isPanning {
                newFrame = NSRect(x: tabView.frame.minX,
                                  y: newFrame.minY,
                                  width: newFrame.width,
                                  height: newFrame.height)

                if !tabIsFocused {
                    newColor = NSColor.gray.cgColor.copy(alpha: 0.5)
                }

            // animate only if the tab is not panning
            } else if animate {
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
        let newDocSize = NSRect(x: 0, y: 0, width: max(frame.width, widthSoFar), height: tabBarViewHeight)
        if animate {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = animationDuration
                scrollView?.documentView?.animator().frame = newDocSize
            })
        } else {
            scrollView?.documentView?.frame = newDocSize
        }
    }

    /// Repositions tabs when one is being dragged around
    /// - Parameters:
    ///   - movingTab: The tab being dragged
    ///   - state: The state of the pan gesture moving the tab
    func repositionTabs(movingTab: TabBarItemView, state: NSPanGestureRecognizer.State) {

        // the point that we use to determine if the tab should be moved
        let referencePoint = NSPoint(x: movingTab.frame.midX, y: 0)
        var repositioned = false

        for (index, tab) in tabViews.enumerated() {
            // ignore deleting and panning tabs
            guard tab.isAlive && !tab.isPanning else { continue }
            if referencePoint.x < tab.frame.maxX && referencePoint.x >= tab.frame.midX {
                // the dragged point is on the right side of this tab
                repositioned = true
                if let movingTabPosition = tabViews.firstIndex(of: movingTab) {
                    tabViews.remove(at: movingTabPosition)
                    let goTo = tabViews.firstIndex(of: tab) ?? (movingTabPosition - 1)
                    tabViews.insert(movingTab, at: goTo + 1)
                }
                break
            } else if referencePoint.x > tab.frame.minX && referencePoint.x < tab.frame.midX {
                // the dragged point is on the left side of this tab
                repositioned = true
                if let movingTabPosition = tabViews.firstIndex(of: movingTab) {
                    tabViews.remove(at: movingTabPosition)
                    tabViews.insert(movingTab, at: index)
                }
                break
            }
        }

        if state == .ended || repositioned {
            // reorder the tabs in tabManager to match tab bar
            tabManager.openedTabs = tabManager.openedTabs.sorted { firstTab, secondTab in
                // find the first instance of each tab
                let firstLocation = tabViews.firstIndex(where: { $0.tabRepresentable.tabID == firstTab.tabID }) ?? -1
                let secondLocation = tabViews.firstIndex(where: { $0.tabRepresentable.tabID == secondTab.tabID }) ?? -1
                return firstLocation < secondLocation
            }
        }

        sizeTabs(animate: (state == .ended) ? true : repositioned)
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        sizeTabs(animate: false)
    }
}
