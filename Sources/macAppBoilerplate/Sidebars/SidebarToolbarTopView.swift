//
//  SidebarToolbarTop.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

struct SidebarToolbarTopView: View {
    var dataSource: SidebarProtocol

    @Binding
    var selection: Int

    @Environment(\.controlActiveState)
    var activeState

    var body: some View {
        HStack(spacing: 2) {
            ForEach(dataSource.items) { icon in
                Button {
                    selection = icon.id
                } label: {
                    Image.makeIcon(
                        named: icon.imageName,
                        title: icon.title
                    )
                }
                .buttonStyle(SidebarToolbarButtonStyle(id: icon.id, selection: selection, activeState: activeState))
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
        .animation(.default, value: dataSource.items)
    }
}
