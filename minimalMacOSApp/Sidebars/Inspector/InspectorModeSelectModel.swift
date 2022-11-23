//
//  InspectorModeSelectModel.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import SwiftUI

final class InspectorModeSelectModel: SidebarModeSelectModel {

    static var shared: InspectorModeSelectModel = .init()

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
