//
//  MainWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController {

    var splitViewController: NSSplitViewController! {
        get { contentViewController as? NSSplitViewController }
        set { contentViewController = newValue }
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        setupSplitView()
        setupToolbar()
    }

    private func setupSplitView() {
        let splitVC = NSSplitViewController()

        let navigatorView = NavigatorSidebar()
        let navigator = NSSplitViewItem(
            sidebarWithViewController: NSHostingController(rootView: navigatorView)
        )
        navigator.titlebarSeparatorStyle = .none
        navigator.minimumThickness = 260
        navigator.collapseBehavior = .useConstraints
        splitVC.addSplitViewItem(navigator)

        let workspaceView = WorkspaceView()
        let mainContent = NSSplitViewItem(
            viewController: NSHostingController(rootView: workspaceView)
        )
        mainContent.titlebarSeparatorStyle = .line
        mainContent.canCollapse = false
        splitVC.addSplitViewItem(mainContent)

//        let inspectorView = InspectorSidebar()
//        let inspector = NSSplitViewItem(
//            viewController: NSHostingController(rootView: inspectorView)
//        )
//        inspector.titlebarSeparatorStyle = .line
//        inspector.minimumThickness = 260
//        inspector.collapseBehavior = .useConstraints
//        splitVC.addSplitViewItem(inspector)

        self.splitViewController = splitVC
    }
}

extension MainWindowController: NSToolbarDelegate {
    func setupToolbar() {
        let toolbar = NSToolbar(identifier: UUID().uuidString)
        toolbar.delegate = self
        toolbar.displayMode = .labelOnly
        toolbar.showsBaselineSeparator = false
        self.window?.titleVisibility = .hidden
        self.window?.toolbarStyle = .unifiedCompact
        self.window?.titlebarAppearsTransparent = false
        self.window?.titlebarSeparatorStyle = .automatic
        self.window?.toolbar = toolbar
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleFirstSidebarItem,
            .flexibleSpace,
//            .showColors
//            .toggleLastSidebarItem
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleFirstSidebarItem,
            .flexibleSpace,
//            .showColors
//            .itemListTrackingSeparator,
//            .toggleLastSidebarItem
        ]
    }

    // swiftlint:disable:next function_body_length
    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case .itemListTrackingSeparator:
            guard let splitViewController = splitViewController else {
                return nil
            }

            return NSTrackingSeparatorToolbarItem(
                identifier: NSToolbarItem.Identifier.itemListTrackingSeparator,
                splitView: splitViewController.splitView,
                dividerIndex: 1
            )
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
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }

    @objc func toggleFirstPanel() {
        guard let firstSplitView = splitViewController.splitViewItems.first else { return }
        firstSplitView.animator().isCollapsed.toggle()
    }

    @objc func toggleLastPanel() {
        guard let lastSplitView = splitViewController.splitViewItems.last else { return }
        lastSplitView.animator().isCollapsed.toggle()

        if lastSplitView.isCollapsed {
            window?.toolbar?.removeItem(at: 1)
//            window?.toolbar?.removeItem(at: 1)
        } else {
            window?.toolbar?.insertItem(
                withItemIdentifier: NSToolbarItem.Identifier.itemListTrackingSeparator,
                at: 1
            )
//            window?.toolbar?.insertItem(
//                withItemIdentifier: NSToolbarItem.Identifier.flexibleSpace,
//                at: 2
//            )
        }
    }
}

private extension NSToolbarItem.Identifier {
    static let toggleFirstSidebarItem = NSToolbarItem.Identifier("ToggleFirstSidebarItem")
    static let toggleLastSidebarItem = NSToolbarItem.Identifier("ToggleLastSidebarItem")
    static let itemListTrackingSeparator = NSToolbarItem.Identifier("ItemListTrackingSeparator")
    //    static let branchPicker = NSToolbarItem.Identifier("BranchPicker")
    //    static let libraryPopup = NSToolbarItem.Identifier("LibraryPopup")
    //    static let runApplication = NSToolbarItem.Identifier("RunApplication")
    //    static let toolbarAppInformation = NSToolbarItem.Identifier("ToolbarAppInformation")
}
