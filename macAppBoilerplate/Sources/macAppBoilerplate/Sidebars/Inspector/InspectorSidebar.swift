//
//  InspectorSidebar.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import SwiftUI

struct InspectorSidebar<Content: View>: View {

    @State
    public var selection: Int = 0

    init(@ViewBuilder viewForSelection: @escaping (Int) -> Content) {
        self.viewForSelection = viewForSelection
    }

    var viewForSelection: (Int) -> Content

    var body: some View {
        VStack {
            viewForSelection(selection)
        }
        .safeAreaInset(edge: .top) {
            InspectorSidebarToolbarTop(selection: $selection)
                .padding(.bottom, -8)
        }
    }
}

struct InspectorSidebar_Previews: PreviewProvider {
    static var previews: some View {
        InspectorSidebar(viewForSelection: { _ in
            Text("HII")
        })
    }
}
