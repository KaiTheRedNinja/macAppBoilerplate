//
//  OutlineView.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

struct OutlineView: NSViewControllerRepresentable {
    typealias NSViewControllerType = OutlineViewController

    init(createController: @escaping (Context) -> OutlineViewController,
         updateController: @escaping (OutlineViewController, Context) -> Void) {
        self.createController = createController
        self.updateController = updateController
    }

    var createController: (Context) -> OutlineViewController
    var updateController: (OutlineViewController, Context) -> Void

    func makeNSViewController(context: Context) -> OutlineViewController {
        createController(context)
    }

    func updateNSViewController(_ nsViewController: OutlineViewController, context: Context) {
        updateController(nsViewController, context)
    }
}
