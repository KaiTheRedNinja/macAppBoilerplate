//
//  SidebarProtocol.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

/// A protocol for sidebars, containing an array of ``SidebarDockIcon`` and a function
/// to turn selections into `AnyView`s. Acts as the data source for both Navigator and Inspector sidebars.
public protocol SidebarProtocol {
    /// An array of ``SidebarDockIcon``s, one for each icon in the sidebar, each corresponding
    /// to a page.
    var items: [SidebarDockIcon] { get set }
    /// Taking in a selection integer corresponding to a page, returns an `AnyView`.
    /// - Parameter selection: An integer corresponding to a page. Index is the `id` of a ``SidebarDockIcon``
    /// - Returns: An `AnyView` for the page
    ///
    /// It is advised to use ``MainContentWrapper(_:)`` to format your view and turn it into an `AnyView`
    func sidebarViewFor(selection: Int) -> AnyView
    /// A boolean for if the sidebar should be shown by default
    func showSidebarFor(sidebarType: SidebarType) -> Bool
}

public extension SidebarProtocol {
    // default implementations
    func sidebarViewFor(selection: Int) -> AnyView {
        MainContentWrapper {
            Text("Needs Implementation")
        }
    }

    func showSidebarFor(sidebarType: SidebarType) -> Bool {
        true
    }
}

public enum SidebarType {
    case navigator
    case inspector
}

class DefaultSidebarProtocol: SidebarProtocol {
    var items: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]
}
