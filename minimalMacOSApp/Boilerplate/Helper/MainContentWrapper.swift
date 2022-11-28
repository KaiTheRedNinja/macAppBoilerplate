//
//  SidebarContainer.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

func MainContentWrapper(_ wrapping: @escaping () -> some View) -> AnyView {
    return AnyView {
        MainContentContainer {
            wrapping()
        }
    }
}

extension AnyView {
    init(_ wrapping: () -> some View) {
        self.init(wrapping())
    }
}

fileprivate struct MainContentContainer<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                content()
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
    }
}
