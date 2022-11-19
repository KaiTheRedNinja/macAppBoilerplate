//
//  SidebarToolbarTop.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

protocol SidebarToolbarTop<ModeModel>: View {

    associatedtype ModeModel: SidebarModeSelectModel

    var selection: Int { get set }
    var model: ModeModel { get }
    var activeState: ControlActiveState { get }

    func changeSelection(to: Int)
}

extension SidebarToolbarTop {

    @ViewBuilder
    var content: some View {
        HStack(spacing: 2) {
            ForEach(model.icons) { icon in
                Button {
                    changeSelection(to: icon.id)
                } label: {
                    model.makeIcon(
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
        .animation(.default, value: model.icons)
    }
}

struct SidebarToolbarButtonStyle: ButtonStyle {
    var id: Int
    var selection: Int
    var activeState: ControlActiveState
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: id == selection ? .semibold : .regular))
            .symbolVariant(id == selection ? .fill : .none)
            .foregroundColor(id == selection ? .accentColor : configuration.isPressed ? .primary : .secondary)
            .frame(width: 25, height: 25, alignment: .center)
            .contentShape(Rectangle())
            .opacity(activeState == .inactive ? 0.45 : 1)
    }
}
