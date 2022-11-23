//
//  InspectorSidebar.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import SwiftUI

struct InspectorSidebar: View {

    @State
    public var selection: Int = 0

    var body: some View {
        VStack {
            switch selection {
            default:
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Text("Needs Implementation")
                        Spacer()
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .top) {
            InspectorSidebarToolbarTop(selection: $selection)
                .padding(.bottom, -8)
        }
    }
}

struct InspectorSidebar_Previews: PreviewProvider {
    static var previews: some View {
        InspectorSidebar()
    }
}
