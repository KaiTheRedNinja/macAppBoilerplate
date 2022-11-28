//
//  TestWindowController.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

class TestWindowController: MainWindowController {
    override func getNavigatorProtocol() -> any NavigatorProtocol {
        TestViewProtocol()
    }
    override func getInspectorProtocol() -> any InspectorProtocol {
        TestViewProtocol()
    }
    override func getWorkspaceProtocol() -> any WorkspaceProtocol {
        TestViewProtocol()
    }
}
