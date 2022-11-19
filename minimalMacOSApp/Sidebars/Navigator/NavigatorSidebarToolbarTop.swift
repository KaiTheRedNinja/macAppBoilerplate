//
//  NavigatorSidebarToolbarTop.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

struct NavigatorSidebarToolbarTop: SidebarToolbarTop {

    typealias ModeModel = NavigatorModeSelectModel

    func changeSelection(to: Int) {
        selection = to
    }

    @Environment(\.controlActiveState)
    var activeState

    @Binding
    var selection: Int

    @StateObject
    var model: NavigatorModeSelectModel = .shared

    var body: some View {
        content
    }
}

struct NavigatorSidebarToolbarTop_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorSidebarToolbarTop(selection: .constant(0))
    }
}
