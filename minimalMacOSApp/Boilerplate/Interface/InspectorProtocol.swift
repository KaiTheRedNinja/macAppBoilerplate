//
//  InspectorProtocol.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

protocol InspectorProtocol<InsView> {
    associatedtype InsView: View
    var inspectorItems: [SidebarDockIcon] { get set }
    func viewForInspectorSidebar(selection: Int) -> InsView
}

class DefaultInspectorProtocol: InspectorProtocol {
    var inspectorItems: [SidebarDockIcon] = [
        .init(imageName: "1.circle", title: "One", id: 0),
        .init(imageName: "2.circle", title: "Two", id: 1),
        .init(imageName: "3.circle", title: "Three", id: 2),
        .init(imageName: "4.circle", title: "Four", id: 3),
        .init(imageName: "5.circle", title: "Five", id: 4)
    ]

    func viewForInspectorSidebar(selection: Int) -> some View {
        SidebarContainer {
            Text("Selection: \(selection)")
        }
    }
}
