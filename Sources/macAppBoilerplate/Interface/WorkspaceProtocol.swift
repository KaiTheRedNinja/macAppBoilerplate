//
//  WorkspaceProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

/// A protocol for sidebars, containing a functionto turn selections into `AnyView`s. Acts as the data source for both Navigator and Inspector sidebars.
public protocol WorkspaceProtocol {
    /// Taking in a selection integer corresponding to a page, returns an `AnyView`.
    /// - Parameter selection: An integer corresponding to a page. Index is the `id` of a ``SidebarDockIcon``
    /// - Returns: An `AnyView` for the page
    ///
    /// It is advised to use ``MainContentWrapper(_:)`` to format your view and turn it into an `AnyView`
    func viewForWorkspace(tab: TabBarID) -> AnyView
}

/// Always returns a `Needs Implementation` message. Used as default when a `WorkspaceProtocol` is not provided.
class DefaultWorkspaceProtocol: WorkspaceProtocol {
    func viewForWorkspace(tab: TabBarID) -> AnyView {
        MainContentWrapper {
            Text("Needs Implementation")
        }
    }
}
