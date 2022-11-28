//
//  OutlineView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

public struct OutlineView: NSViewControllerRepresentable {
    public typealias NSViewControllerType = OutlineViewController

    public init(createController: @escaping (Context) -> OutlineViewController,
         updateController: @escaping (OutlineViewController, Context) -> Void = { _, _ in }) {
        self.createController = createController
        self.updateController = updateController
    }

    var createController: (Context) -> OutlineViewController
    var updateController: (OutlineViewController, Context) -> Void

    public func makeNSViewController(context: Context) -> OutlineViewController {
        createController(context)
    }

    public func updateNSViewController(_ nsViewController: OutlineViewController, context: Context) {
        updateController(nsViewController, context)
    }
}
