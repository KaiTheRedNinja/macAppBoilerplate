//
//  TabBarItemID.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

public enum TabBarItemID: Identifiable, Hashable {
    public var id: String {
        switch self {
        case .test(let string):
            return "_test_\(string)"
        }
    }

    case test(String)
}
