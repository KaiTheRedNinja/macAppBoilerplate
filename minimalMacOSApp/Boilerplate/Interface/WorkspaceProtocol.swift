//
//  WorkspaceProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

protocol WorkspaceProtocol<WSView> {
    associatedtype WSView: View

    func viewForWorkspace(tab: TabBarID) -> WSView
}

class DefaultWorkspaceProtocol: WorkspaceProtocol {
    func viewForWorkspace(tab: TabBarID) -> some View {
        MainContentContainer {
            if let tab = tab as? TestTabBarID {
                switch tab {
                case .test(let string):
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            Text("Test: \(string)")
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Wrong Format")
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
