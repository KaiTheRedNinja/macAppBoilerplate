//
//  TabBarItem.swift
//  minimalMacOSApp
//
//  Created by Kai Quan Tay on 19/11/22.
//

import SwiftUI

struct TabBarItem: View {

    @Environment(\.isFullscreen)
    private var isFullscreen

    @Environment(\.controlActiveState)
    var activeState

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var tabManager: TabManager = .shared

    @State
    var isHovering: Bool = false

    @State
    var isHoveringClose: Bool = false

    @State
    var isPressingClose: Bool = false

    @State
    var isAppeared: Bool = false

    @Binding
    private var expectedWidth: CGFloat

    var item: TabBarItemRepresentable

    var isActive: Bool {
        item.tabID == tabManager.selectedTab
    }

    func switchAction() {
        // Only set the `selectedId` when they are not equal to avoid performance issue for now.
        if tabManager.selectedTab != item.tabID {
            tabManager.selectedTab = item.tabID
        }
    }

    func closeAction() {
        withAnimation(
            .easeOut( duration: 0.20 )
        ) {
            tabManager.closeTab(id: item.tabID)
        }
    }

    init(
        expectedWidth: Binding<CGFloat>,
        item: TabBarItemRepresentable
    ) {
        self._expectedWidth = expectedWidth
        self.item = item
    }

    @ViewBuilder
    var content: some View {
        HStack(spacing: 0.0) {
            TabDivider()
                .opacity(isActive ? 0.0 : 1.0)
                .padding(.top, isActive ? 0 : 1.22)
            // Tab content (icon and text).
            iconTextView
                .opacity(
                    // Inactive states for tab bar item content.
                    activeState != .inactive ? 1.0 :
                        ( isActive ? 0.6 : 0.4 )
                )
        }
        .foregroundColor(
            isActive ? .primary : .secondary
        )
        .frame(maxHeight: .infinity) // To vertically max-out the parent (tab bar) area.
        .contentShape(Rectangle()) // Make entire area clickable.
        .onHover { hover in
            isHovering = hover
            DispatchQueue.main.async {
                if hover {
                    NSCursor.arrow.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }

    @ViewBuilder
    var iconTextView: some View {
        HStack(alignment: .center, spacing: 5) {
            item.icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.secondary)
                .frame(width: 12, height: 12)
            Text(item.title)
                .font(.system(size: 11.0))
                .lineLimit(1)
        }
        .frame(
            // To max-out the parent (tab bar) area.
            maxHeight: .infinity
        )
        .padding(.horizontal, 23)
        .overlay {
            ZStack {
                if isActive {
                    // Close Tab Shortcut:
                    // Using an invisible button to contain the keyboard shortcut is simply
                    // because the keyboard shortcut has an unexpected bug when working with
                    // custom buttonStyle. This is an workaround and it works as expected.
                    Button(
                        action: closeAction,
                        label: { EmptyView() }
                    )
                    .frame(width: 0, height: 0)
                    .padding(0)
                    .opacity(0)
                    .keyboardShortcut("w", modifiers: [.command])
                }
                // Switch Tab Shortcut:
                // Using an invisible button to contain the keyboard shortcut is simply
                // because the keyboard shortcut has an unexpected bug when working with
                // custom buttonStyle. This is an workaround and it works as expected.
                Button(
                    action: switchAction,
                    label: { EmptyView() }
                )
                .frame(width: 0, height: 0)
                .padding(0)
                .opacity(0)
                .background(.blue)
                // Close button.
                Button(action: closeAction) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11.2, weight: .regular, design: .rounded))
                        .frame(width: 16, height: 16)
                        .foregroundColor(
                            isActive
                            ? (
                                colorScheme == .dark
                                ? .primary
                                : Color(nsColor: .controlAccentColor)
                            )
                            : .secondary.opacity(0.80)
                        )
                }
                .buttonStyle(.borderless)
                .foregroundColor(isPressingClose ? .primary : .secondary)
                .background(
                    colorScheme == .dark
                    ? Color(nsColor: .white)
                        .opacity(isPressingClose ? 0.32 : isHoveringClose ? 0.18 : 0)
                    : Color(nsColor: isActive ? .controlAccentColor : .black)
                        .opacity(
                            isPressingClose
                            ? 0.25
                            : (isHoveringClose ? (isActive ? 0.10 : 0.06) : 0)
                        )
                )
                .cornerRadius(2)
                .accessibilityLabel(Text("Close"))
                .onHover { hover in
                    isHoveringClose = hover
                }
                .opacity(isHovering ? 1 : 0)
                .animation(.easeInOut(duration: 0.08), value: isHovering)
                .padding(.leading, 3.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var body: some View {
        Button(
            action: switchAction,
            label: { content }
        )
        .buttonStyle(TabBarItemButtonStyle())
        .background {
            ZStack {
                // This layer of background is to hide dividers of other tab bar items
                // because the original background above is translucent (by opacity).
                EffectView(
                    NSVisualEffectView.Material.contentBackground,
                    blendingMode: NSVisualEffectView.BlendingMode.withinWindow
                )
                if isActive {
                    Color(nsColor: .controlAccentColor)
                        .saturation(
                            colorScheme == .dark
                            ? (activeState != .inactive ? 0.60 : 0.75)
                            : (activeState != .inactive ? 0.90 : 0.85)
                        )
                        .opacity(
                            colorScheme == .dark
                            ? (activeState != .inactive ? 0.50 : 0.35)
                            : (activeState != .inactive ? 0.18 : 0.12)
                        )
                        .hueRotation(.degrees(-5))
                }
            }
            .animation(.easeInOut(duration: 0.08), value: isHovering)
        }
        .padding(
            // This padding is to avoid background color overlapping with top divider.
            .top, 1
        )
        .opacity(isAppeared ? 1.0 : 0.0)
        .zIndex(isActive ? 1 : 0)
        .onAppear {
            withAnimation(.linear(duration: 0.0)) {
                isAppeared = true
            }
        }
        .id(item.tabID)
//        .tabBarContextMenu(item: item, workspace: workspace, isTemporary: isTemporary)
    }
}

struct TabBarItemButtonStyle: ButtonStyle {
    @Environment(\.colorScheme)
    var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                ? (colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.09))
                : .clear
            )
    }
}

/// The vertical divider between tab bar items.
struct TabDivider: View {
    @Environment(\.colorScheme)
    var colorScheme

    let width: CGFloat = 1

    var body: some View {
        Rectangle()
            .frame(width: width)
            .padding(.vertical, 8)
            .foregroundColor(Color(nsColor: colorScheme == .dark ? .white : .black)
                .opacity(0.12))
    }
}

extension EnvironmentValues {
    private struct WorkspaceFullscreenStateEnvironmentKey: EnvironmentKey {
        static let defaultValue: Bool = false
    }

    var isFullscreen: Bool {
        get { self[WorkspaceFullscreenStateEnvironmentKey.self] }
        set { self[WorkspaceFullscreenStateEnvironmentKey.self] = newValue }
    }
}
