//
//  NavigatorSidebar.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 18/11/22.
//

import SwiftUI

struct NavigatorSidebar: View {

    @State
    public var selection: Int = 0

    var body: some View {
        VStack {
            switch selection {
            case 0:
                OutlineView { _ in
                    TestOutlineViewController()
                }
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
            NavigatorSidebarToolbarTop(selection: $selection)
                .padding(.bottom, -8)
        }
    }
}

struct NavigatorSidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorSidebar()
    }
}
