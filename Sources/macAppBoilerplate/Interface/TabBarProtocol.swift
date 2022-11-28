//
//  TabBarProtocol.swift
//  
//
//  Created by Kai Quan Tay on 28/11/22.
//

import SwiftUI

public protocol TabBarProtocol {
    func minimumTabWidth() -> CGFloat?
    func tabBecomesSmall() -> CGFloat?
    func maximumTabWidth() -> CGFloat?
    func animationDuration() -> CGFloat?
    func tabBarViewHeight() -> CGFloat?
    func disableTabs() -> Bool?
}

class DefaultTabBarProtocol: TabBarProtocol {
    func minimumTabWidth() -> CGFloat? { 60 }
    func tabBecomesSmall() -> CGFloat? { 60 }
    func maximumTabWidth() -> CGFloat? { 120 }
    func animationDuration() -> CGFloat? { 0.3 }
    func tabBarViewHeight() -> CGFloat? { 28 }
    func disableTabs() -> Bool? { false }
}
