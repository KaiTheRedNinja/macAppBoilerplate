//
//  NavigatorModeSelectModel.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

class NavigatorModeSelectModel: ObservableObject {
    static let shared: NavigatorModeSelectModel = .init()
    var icons: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]

    func makeIcon(named: String, title: String) -> some View {
        getSafeImage(named: named, accesibilityDescription: title)
            .help(title)
    }

    private func getSafeImage(named: String, accesibilityDescription: String?) -> Image {
        if let nsImage = NSImage(
            systemSymbolName: named,
            accessibilityDescription: accesibilityDescription
        ) {
            return Image(nsImage: nsImage)
        } else {
            return Image(named)
        }
    }
}

struct SidebarDockIcon: Identifiable, Equatable {
    let imageName: String
    let title: String
    var id: Int
}

struct NavigatorToolbarButtonStyle: ButtonStyle {
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
