//
//  NavigatorSidebarToolbarTop.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

struct NavigatorSidebarToolbarTop: View {

    @Environment(\.controlActiveState)
    private var activeState

    @Binding
    var selection: Int

    @StateObject
    var model: NavigatorModeSelectModel = .shared

    var body: some View {
        HStack(spacing: 2) {
            ForEach(model.icons) { icon in
                Button {
                    selection = icon.id
                } label: {
                    model.makeIcon(
                        named: icon.imageName,
                        title: icon.title
                    )
                }
                .buttonStyle(NavigatorToolbarButtonStyle(id: icon.id, selection: selection, activeState: activeState))
                .imageScale(.medium)
            }
        }
        .frame(height: 29, alignment: .center)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            Divider()
        }
        .overlay(alignment: .bottom) {
            Divider()
        }
        .animation(.default, value: model.icons)
    }
}

struct NavigatorSidebarToolbarTop_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorSidebarToolbarTop(selection: .constant(0))
    }
}
