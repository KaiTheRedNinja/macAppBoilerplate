//
//  WorkspaceProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

protocol WorkspaceProtocol {
    func viewForWorkspace(tab: TabBarID) -> AnyView
}

class DefaultWorkspaceProtocol: WorkspaceProtocol {
    func viewForWorkspace(tab: TabBarID) -> AnyView {
        MainContentWrapper {
            ZStack {
                if let tab = tab as? TestTabBarID {
                    switch tab {
                    case .test(let string):
                        Text("Test: \(string)")
                    }
                } else {
                    Text("Wrong Format")
                }
            }
        }
    }
}
