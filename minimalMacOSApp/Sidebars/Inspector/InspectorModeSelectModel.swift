//
//  InspectorModeSelectModel.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import SwiftUI

final class InspectorModeSelectModel: SidebarModeSelectModel {

    static var shared: InspectorModeSelectModel = .init()

    var icons: [SidebarDockIcon] = []

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
