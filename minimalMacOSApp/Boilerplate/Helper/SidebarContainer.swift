//
//  SidebarContainer.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 27/11/22.
//

import SwiftUI

struct SidebarContainer<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                content()
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
    }
}
