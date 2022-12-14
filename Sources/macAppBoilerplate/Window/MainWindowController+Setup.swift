//
//  MainWindowController+Setup.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 26/11/22.
//

import SwiftUI

extension MainWindowController {

    /// The split view controller that the window controller controls
    var splitViewController: NSSplitViewController! {
        get { contentViewController as? NSSplitViewController }
        set { contentViewController = newValue }
    }

    open override func windowDidLoad() {
        super.windowDidLoad()

        // set up the protocols
        self.navigatorProtocol = getNavigatorProtocol()
        self.inspectorProtocol = getInspectorProtocol()
        self.workspaceProtocol = getWorkspaceProtocol()
        self.tabManager = TabManager()
        tabManager.dataSource = getTabBarProtocol()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        setupSplitView()
        setupToolbar()

        // collapse/show as needed
        if !navigatorProtocol.showSidebarFor(sidebarType: .navigator) {
            splitViewController.splitViewItems.first?.isCollapsed = true
        }
        if !inspectorProtocol.showSidebarFor(sidebarType: .inspector) {
            splitViewController.splitViewItems.last?.isCollapsed = true
            manageLastPanelToolbarItems()
        }
    }

    // init the toolbar and do some basic setup
    private func setupToolbar() {
        let toolbar = NSToolbar(identifier: UUID().uuidString)
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        toolbar.showsBaselineSeparator = false
        if let window {
            window.toolbar = toolbar
            tabManager.dataSource.configWindow(window)
        }
    }

    private func setupSplitView() {
        // create the split view
        let splitVC = NSSplitViewController()

        // add the navigator sidebar view
        let navigatorView = SidebarView(dataSource: navigatorProtocol).environmentObject(tabManager)
        let navigator = NSSplitViewItem(
            sidebarWithViewController: NSHostingController(rootView: navigatorView)
        )
        navigator.titlebarSeparatorStyle = .none
        if let min = navigatorProtocol.getMinimumThickness() {
            navigator.minimumThickness = min
        }
        if let max = navigatorProtocol.getMaximumThickness() {
            navigator.maximumThickness = max
        }
        navigator.collapseBehavior = .useConstraints
        splitVC.addSplitViewItem(navigator)

        // add the workspace view (middle view)
        let workspaceView = WorkspaceView(viewForTab: { tab in
            self.workspaceProtocol.viewForWorkspace(tab: tab)
        }).environmentObject(tabManager)
        let mainContent = NSSplitViewItem(
            viewController: NSHostingController(rootView: workspaceView)
        )
        mainContent.titlebarSeparatorStyle = .line
        mainContent.canCollapse = false
        splitVC.addSplitViewItem(mainContent)

        // add the inspector sidebar view
        let inspectorView = SidebarView(dataSource: inspectorProtocol).environmentObject(tabManager)
        let inspector = NSSplitViewItem(
            sidebarWithViewController: NSHostingController(rootView: inspectorView)
        )
        inspector.titlebarSeparatorStyle = .line
        if let min = inspectorProtocol.getMinimumThickness() {
            inspector.minimumThickness = min
        }
        if let max = inspectorProtocol.getMaximumThickness() {
            inspector.maximumThickness = max
        }
        inspector.collapseBehavior = .useConstraints
        splitVC.addSplitViewItem(inspector)

        // make this window controller's view the splitVC
        self.splitViewController = splitVC
    }

    /// Gets the built in default toolbar item for an identifier, or nil if it is not a default toolbar item
    public func builtinDefaultToolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        // Track the inspector sidebar~
        case .itemListTrackingSeparator:
            guard let splitViewController = splitViewController else {
                return nil
            }

            return NSTrackingSeparatorToolbarItem(
                identifier: NSToolbarItem.Identifier.itemListTrackingSeparator,
                splitView: splitViewController.splitView,
                dividerIndex: 1
            )
        // Button to toggle navigator sidebar
        case .toggleFirstSidebarItem:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleFirstSidebarItem)
            toolbarItem.label = "Navigator Sidebar"
            toolbarItem.paletteLabel = "Navigator Sidebar"
            toolbarItem.toolTip = "Hide or show the Navigator"
            toolbarItem.isBordered = true
            toolbarItem.target = self
            toolbarItem.action = #selector(self.toggleFirstPanel)
            toolbarItem.image = NSImage(
                systemSymbolName: "sidebar.leading",
                accessibilityDescription: nil
            )?.withSymbolConfiguration(.init(scale: .large))

            return toolbarItem
        // Button to toggle inspector sidebar
        case .toggleLastSidebarItem:
            let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.toggleLastSidebarItem)
            toolbarItem.label = "Inspector Sidebar"
            toolbarItem.paletteLabel = "Inspector Sidebar"
            toolbarItem.toolTip = "Hide or show the Inspectors"
            toolbarItem.isBordered = true
            toolbarItem.target = self
            toolbarItem.action = #selector(self.toggleLastPanel)
            toolbarItem.image = NSImage(
                systemSymbolName: "sidebar.trailing",
                accessibilityDescription: nil
            )?.withSymbolConfiguration(.init(scale: .large))

            return toolbarItem
        default:
            return nil
        }
    }

    /// Toggles the first panel, the Navigator Sidebar
    @objc func toggleFirstPanel() {
        guard let firstSplitView = splitViewController.splitViewItems.first else { return }
        firstSplitView.animator().isCollapsed.toggle()
    }

    /// Toggles the last panel, the Inspector Sidebar and calls `manageLstPanelToolbarItems` to clean up the menu bar.
    @objc func toggleLastPanel() {
        guard let lastSplitView = splitViewController.splitViewItems.last else { return }
        lastSplitView.animator().isCollapsed.toggle()
        manageLastPanelToolbarItems()
    }

    func manageLastPanelToolbarItems() {
        guard let lastSplitView = splitViewController.splitViewItems.last,
              let toolbar = window?.toolbar
        else { return }

        let itemCount = toolbar.items.count
        if lastSplitView.isCollapsed {
            // remove the spacer and tracker
            toolbar.removeItem(at: itemCount-3) // -1 is the last item, -2 is the second last
            toolbar.removeItem(at: itemCount-3) // this removes the second last and the third last
        } else {
            // insert the spacer and tracker
            toolbar.insertItem(
                withItemIdentifier: NSToolbarItem.Identifier.itemListTrackingSeparator,
                at: itemCount-1 // insert it as second last
            )
            toolbar.insertItem(
                withItemIdentifier: NSToolbarItem.Identifier.flexibleSpace,
                at: itemCount-0 // insert it as "last" (actually second last now)
            )
        }
    }

    /// The default leading items (leading sidebar items)
    public func defaultLeadingItems(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleFirstSidebarItem,
            .sidebarTrackingSeparator
        ]
    }

    /// The default trailing items (trailing sidebar items and tracker)
    public func defaultTrailingItems(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .itemListTrackingSeparator,
            .flexibleSpace,
            .toggleLastSidebarItem
        ]
    }
}

private extension NSToolbarItem.Identifier {
    static let toggleFirstSidebarItem = NSToolbarItem.Identifier("ToggleFirstSidebarItem")
    static let toggleLastSidebarItem = NSToolbarItem.Identifier("ToggleLastSidebarItem")
    static let itemListTrackingSeparator = NSToolbarItem.Identifier("ItemListTrackingSeparator")
}
