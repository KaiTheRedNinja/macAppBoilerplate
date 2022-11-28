//
//  SidebarView.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

struct SidebarView: View {

    @State
    public var selection: Int = 0

    var dataSource: any SidebarProtocol

    init(dataSource: SidebarProtocol) {
        self.dataSource = dataSource
        self.viewForSelection = dataSource.sidebarViewFor(selection:)
    }

    var viewForSelection: (Int) -> AnyView

    var body: some View {
        VStack {
            viewForSelection(selection)
        }
        .safeAreaInset(edge: .top) {
            SidebarToolbarTopView(dataSource: dataSource, selection: $selection)
                .padding(.bottom, -8)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(dataSource: DefaultSidebarProtocol())
    }
}

