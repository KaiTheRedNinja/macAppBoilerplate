//
//  WorkspaceProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

public protocol WorkspaceProtocol {
    func viewForWorkspace(tab: TabBarID) -> AnyView
}

class DefaultWorkspaceProtocol: WorkspaceProtocol {
    func viewForWorkspace(tab: TabBarID) -> AnyView {
        MainContentWrapper {
            Text("Needs Implementation")
        }
    }
}
