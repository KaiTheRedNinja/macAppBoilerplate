//
//  TabBarItemID.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

/// Essentially Identifiable but only `String`s. Used for identifying tabs.
public protocol TabBarID {
    var id: String { get }
}

extension TabBarID {
    static func == (lhs: TabBarID, rhs: TabBarID) -> Bool {
        lhs.id == rhs.id
    }
}
