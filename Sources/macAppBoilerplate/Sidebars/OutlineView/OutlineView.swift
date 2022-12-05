//
//  OutlineView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

/// A struct to contain any ``OutlineViewController`` easily in a `View`
public struct OutlineView: NSViewControllerRepresentable {
    public typealias NSViewControllerType = OutlineViewController

    @EnvironmentObject
    var tabManger: TabManager

    // Accept two escaping closures, one for creation and one for updating the controller
    public init(createController: @escaping (Context) -> OutlineViewController,
                updateController: @escaping (OutlineViewController, Context) -> Void = { _, _ in }) {
        self.createController = createController
        self.updateController = updateController
    }

    /// Function to create an outline controller
    var createController: (Context) -> OutlineViewController
    /// Function to update the controller
    var updateController: (OutlineViewController, Context) -> Void

    public func makeNSViewController(context: Context) -> OutlineViewController {
        let controller = createController(context)
        controller.tabManager = self.tabManger
        return controller
    }

    public func updateNSViewController(_ nsViewController: OutlineViewController, context: Context) {
        updateController(nsViewController, context)
        if nsViewController.tabManager != self.tabManger {
            nsViewController.tabManager = self.tabManger
        }
    }
}
