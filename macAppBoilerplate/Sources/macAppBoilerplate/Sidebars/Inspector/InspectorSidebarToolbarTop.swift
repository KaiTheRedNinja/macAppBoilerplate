//
//  InspectorSidebarToolbarTop.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 23/11/22.
//

import SwiftUI

struct InspectorSidebarToolbarTop: SidebarToolbarTop {

    typealias ModeModel = InspectorModeSelectModel

    func changeSelection(to: Int) {
        selection = to
    }

    @Environment(\.controlActiveState)
    var activeState

    @Binding
    var selection: Int

    @StateObject
    var model: InspectorModeSelectModel = .shared

    var body: some View {
        content
    }
}

struct InspectorSidebarToolbarTop_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorSidebarToolbarTop(selection: .constant(0))
    }
}
