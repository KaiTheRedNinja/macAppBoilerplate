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
        for tab in tabManager.openedTabs {
            if !tabViews.map({ $0.tabRepresentable.tabID }).contains(tab.tabID) {
                print("Tab added: \(tab.tabID)")
                let newItem = TabBarItemView()
                newItem.tabRepresentable = tab
                newItem.addViews(rect: .zero)
                tabViews.append(newItem)
            }
        }
        sizeTabs()
    }

    func sizeTabs(animate: Bool = true) {
        print("Updating size of tabs with animation \(animate)")
        scrollView?.frame = self.frame
        let widthOfTabView = self.frame.width

        // determine the maximum width of a tab
        let numberOfTabs = tabManager.openedTabs.count
        var idealWidth: CGFloat = minimumTabWidth

        if tabManager.selectedTab == nil {
            // if no selected tabs
            idealWidth = widthOfTabView/CGFloat(numberOfTabs)
        } else {
            // if has selected tab, size it appropriately.
            // we subtract the size of the selected tab to make the tabs have
            // a correct-looking size
            idealWidth = widthOfTabView-maximumTabWidth/CGFloat(numberOfTabs-1)
        }

        // pin idealWidth between the minimum and maximum tab sizes
        idealWidth = max(minimumTabWidth, min(idealWidth, maximumTabWidth))
        print("Ideal width: \(idealWidth)")

        // iterate over the tabs and size them as needed
        var widthSoFar: CGFloat = 0
        for tabView in self.tabViews {
            // make sure that the tab is in the scroll subview
            if tabView.superview != scrollView?.documentView {
                print("Tab \(tabView.tabRepresentable.tabID) added to scroll view")
                tabView.removeFromSuperview()
                scrollView?.documentView?.addSubview(tabView)
            }

            // if the tab is marked as dead, animate its width to 0 and remove it
            if !tabView.isAlive {
                print("Tab \(tabView.tabRepresentable.tabID) is dead")
                tabView.frame = NSRect(x: widthSoFar, y: 0, width: 0, height: 30)
                self.tabViews.removeAll(where: { $0.tabRepresentable.tabID == tabView.tabRepresentable.tabID })
                // no need to increment widthSoFar as the tab will have no width
            }

            // size the tab to the ideal width
            let tabIsFocused = tabManager.selectedTab == tabView.tabRepresentable.tabID

            if tabIsFocused {
                // if its focused, size it to be the maximum size
                tabView.frame = NSRect(x: widthSoFar, y: 0, width: maximumTabWidth, height: 30)
                widthSoFar += maximumTabWidth
            } else {
                // if it is not focused, size it to be the ideal size
                tabView.frame = NSRect(x: widthSoFar, y: 0, width: idealWidth, height: 30)
                widthSoFar += idealWidth
            }
            print("Width so far: \(widthSoFar)")
        }

        // set the document view size
        scrollView?.documentView?.frame = NSRect(x: 0, y: 0, width: widthSoFar, height: 30)
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        sizeTabs(animate: false)
    }
}
