//
//  SidebarModeSelectModel.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import Foundation
import SwiftUI

protocol SidebarModeSelectModel: ObservableObject {
    static var shared: Self { get }

    var icons: [SidebarDockIcon] { get set }
}

extension SidebarModeSelectModel {
    @ViewBuilder
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
