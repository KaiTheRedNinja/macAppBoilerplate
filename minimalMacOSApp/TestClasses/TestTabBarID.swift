//
//  TestTabBarID.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 24/11/22.
//

import Foundation

public enum TestTabBarID: TabBarID {
    public var id: String {
        switch self {
        case .test(let string):
            return "_test_\(string)"
        }
    }

    case test(String)
}
