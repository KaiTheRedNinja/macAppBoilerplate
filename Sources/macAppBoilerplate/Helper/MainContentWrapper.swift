//
//  SidebarContainer.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

/// Wraps a ``MainContentWrapper(_:)`` in an `AnyView` for type-erased wrapping
public func MainContentWrapper(_ wrapping: @escaping () -> some View) -> AnyView {
    return AnyView {
        MainContentContainer {
            wrapping()
        }
    }
}

extension AnyView {
    /// Allow for external closure syntax for AnyView
    init(_ wrapping: () -> some View) {
        self.init(wrapping())
    }
}

/// Wraps a `View` so that it expands to fit the space,
/// meant for use in sidebars or main content
fileprivate struct MainContentContainer<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        // center the content and set it to maxwidth and maxheight infinity
        VStack(alignment: .center) {
            HStack {
                content()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxHeight: .infinity)
    }
}
