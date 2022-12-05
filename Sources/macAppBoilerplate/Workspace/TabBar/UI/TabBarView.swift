//
//  TabBarView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import Cocoa

/// A view for a tab bar
class TabBarView: NSView {
    /// The scroll view that the tab bar manages
    var scrollView: NSScrollView?
    /// The tab manager
    var tabManager: TabManager!
    /// The views for tab items
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
        scrollView?.verticalScrollElasticity = .none
        addSubview(scrollView!)
    }

    /// Updates the tab views, creating and deleting them as needed
    func updateTabs() {
        // iterate over tabs and mark those that don't exist anymore as dead
        for tabView in tabViews {
            if !tabManager.openedTabs.contains(where: { $0.tabID.id == tabView.tabRepresentable.tabID.id }) {
                tabView.isAlive = false
            }
        }

        // iterate over tabs and create new ones as needed
        var newTabs = tabViews
        for (index, tab) in tabManager.openedTabs.enumerated() {
            if !tabViews.contains(where: { $0.tabRepresentable.tabID.id == tab.tabID.id }) {
                let newItem = TabBarItemView()
                newItem.tabBarView = self
                newItem.tabManager = self.tabManager
                newItem.tabRepresentable = tab
                newItem.addViews(rect: .zero)
                if index-1 < newTabs.count && index-1 >= 0 {
                    newItem.frame = NSRect(x: newTabs[index-1].frame.maxX, y: 0, width: 0, height: tabManager.dataSource.tabBarViewHeight)
                } else {
                    newItem.frame = NSRect(x: 0, y: 0, width: 0, height: tabManager.dataSource.tabBarViewHeight)
                }
                newItem.resizeSubviews(withOldSize: .zero)
                newTabs.insert(newItem, at: index)
            }
        }
        self.tabViews = newTabs
        sizeTabs()
    }

    /// Change the frames of the tab views, animating it as needed
    func sizeTabs(animate: Bool = true) {
        scrollView?.frame = self.frame
        let widthOfTabView = self.frame.width

        // determine the maximum width of a tab
        let numberOfTabs = tabManager.openedTabs.count
        var idealWidth: CGFloat = tabManager.dataSource.minimumTabWidth

        idealWidth = widthOfTabView/CGFloat(numberOfTabs)

        // pin idealWidth between the minimum and maximum tab sizes
        idealWidth = max(tabManager.dataSource.minimumTabWidth, min(idealWidth, tabManager.dataSource.maximumTabWidth))

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
                    context.duration = tabManager.dataSource.animationDuration

                    // change the width to 0
                    tabView.animator().frame = NSRect(x: widthSoFar, y: 0, width: 0, height: tabManager.dataSource.tabBarViewHeight)

                    // change the opacity
                    tabView.animator().alphaValue = 0.0
                }) {
                    // on completion, remove the tab view
                    tabView.removeFromSuperview()
                    self.tabViews.removeAll(where: { $0.tabRepresentable.tabID.id ==
                        tabView.tabRepresentable.tabID.id })
                }
                // no need to increment widthSoFar as the tab will have no width
                continue
            }

            // size the tab to the ideal width
            let tabIsFocused = tabManager.selectedTab?.id == tabView.tabRepresentable.tabID.id
            tabView.manageDividers()

            var newFrame = tabView.frame
            var newColor: CGColor?

            if tabIsFocused {
                // if its focused, size it to be the maximum size
                newFrame = NSRect(x: widthSoFar, y: 0,
                                  width: tabManager.dataSource.maximumTabWidth * (tabView.zoomAmount + 1),
                                  height: tabManager.dataSource.tabBarViewHeight)
                newColor = NSColor.controlAccentColor.cgColor.copy(alpha: 0.5)
                widthSoFar += tabManager.dataSource.maximumTabWidth * (tabView.zoomAmount + 1)
            } else {
                // if it is not focused, size it to be the ideal size
                newFrame = NSRect(x: widthSoFar, y: 0, width: idealWidth * (tabView.zoomAmount + 1), height: tabManager.dataSource.tabBarViewHeight)
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
                    context.duration = tabManager.dataSource.animationDuration
                    tabView.animator().frame = newFrame
                })
            } else {
                tabView.frame = newFrame
            }
            tabView.layer?.backgroundColor = newColor
        }

        // set the document view size
        let newDocSize = NSRect(x: 0, y: 0, width: max(frame.width, widthSoFar), height: tabManager.dataSource.tabBarViewHeight)
        if animate {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = tabManager.dataSource.animationDuration
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
                let firstLocation = tabViews.firstIndex(where: { $0.tabRepresentable.tabID.id ==
                    firstTab.tabID.id }) ?? -1
                let secondLocation = tabViews.firstIndex(where: { $0.tabRepresentable.tabID.id ==
                    secondTab.tabID.id }) ?? -1
                return firstLocation < secondLocation
            }
        }

        sizeTabs(animate: (state == .ended) ? true : repositioned)
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        sizeTabs(animate: false)
    }
}
