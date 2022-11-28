//
//  SidebarDockIcon.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

public struct SidebarDockIcon: Identifiable, Equatable {
    public let imageName: String
    public let title: String
    public var id: Int

    public init(imageName: String, title: String, id: Int) {
        self.imageName = imageName
        self.title = title
        self.id = id
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

extension Image {
    static func makeIcon(named: String, title: String) -> some View {
        getSafeImage(named: named, accesibilityDescription: title)
            .help(title)
    }

    private static func getSafeImage(named: String, accesibilityDescription: String?) -> Image {
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
