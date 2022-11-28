# macAppBoilerplate
A library that provides boilerplate for an Xcode-like macOS app UI.

Majority of behaviour and code extracted from AuroraEditor.

## Implementation Details

### Basic architecture
- Window and Sidebar behaviour:
  - `MainWindowController`: A Window Controller that creates the basic UI
  - `NavigatorProtocol`: A protocol which defines the behaviour of the Navigator sidebar (on the left)
  - `InspectorProtocol`: A protocol which defines the behaviour of the Inspector sidebar (on the right)
  - `WorkspaceProtocol`: A protocol which defines the behaviour of the main tab content (in the center)
- Outline Views:
  - `OutlineViewController`: An NSViewController that controls an NSOutlineView in an NSScrollView
  - `OutlineElement`: A protocol for an item in `OutlineViewController`, for use in `StandardTableViewCell`
  - `StandardTableViewCell`: A class for a row in `OutlineViewController`. Intended to be subclassed.
- Tab Bar:
  - `TabBarID`: A protocol that includes an ID. Intended to be implemented on an Enum, so that each tab has an assigned `case`.
  - `TabBarRepresentable`: A protocol that provides information like the title and icon to show for a tab. Intended to be implemented on a class or struct.

## Usage

See [the example repo](https://github.com/KaiTheRedNinja/minimalMacOSApp.git) for reference

### Modifying the Navigator or Inspector Sidebar pages
1. Create a class conforming to `NavigatorProtocol` or `InspectorProtocol`. Add new pages
by creating new `SidebarDockIcon` instances in `navigatorItems` or `inspectorItems` like so:

```swift
.init(imageName: "symbolName", title: "hoverTitle", id: 0)
``` 

2. Override the `viewForNavigationSidebar(selection: Int) -> AnyView` or `viewForInspectorSidebar(selection: Int) -> AnyView` functions.
Use `MainContentWrapper` to wrap your View so that it is formatted properly, eg:

```swift
func viewForNavigationSidebar(selection: Int) -> AnyView {
    MainContentWrapper {
        switch selection {
        case 0:
            // things to show on page 0
            Text("PAGE ZERO")
        // add more cases as needed
        default:
            Text("Not Implemented Yet")
        }
    }
}
```

Add an extra case to the `selection` switch statement (the number you use is the `id`
of your `SidebarDockIcon`). Put your view there, and it will be visible when that tab is
selected.

3. Override the default `NavigatorProtocol` in your `MainWindowController` subclass 
by overriding the `func getNavigatorProtocol() -> any NavigatorProtocol` or `func getInspectorProtocol() -> any InspectorProtocol` function, eg:

```swift
override func getNavigatorProtocol() -> any NavigatorProtocol {
    return MyNavigatorProtocol()
}
```

### Creating new tab types
#### Creating the data classes for the tab
1. Create an enum conforming to `TabBarItemID`. You should ONLY MAKE **ONE** in the entire project, and add cases for other tabs
2. Add a case to your enum. This case can hold information (eg. by using `case myCase(String)` to hold a string).
3. To store data for the tab type, create a class conforming to `TabBarItemRepresentable`. See the `test` case and the `TestElement` class as an example
   in [the example repo](https://github.com/KaiTheRedNinja/minimalMacOSApp.git)
  - To open a new tab, use the `openTab` function of the `TabManager` shared instance. 
  - Similarly, use the `closeTab` function to close your tab.

#### Creating the UI for the tab
1. Create a class conforming to `WorkspaceProtocol`
2. Implement the `viewForTab(tab: TabBarItemID) -> AnyView` function. You can use the following as a base:

```swift
func viewForTab(tab: TabBarItemID) -> AnyView {
    MainContentWrapper {
        if let tab = tab as? MyTabBarItemID {
            switch tab {
            case .myCase(let string):
                // things to show on page 0
                Text("My Case: \(string)")
            // add more cases as needed
            default:
                Text("Not Implemented Yet")
            }
        }
    }
}
```

3. Override the default `WorkspaceProtocol` in your `MainViewController` subclass by overriding the 
   `funcc getWorkspaceProtocol() -> any WorkspaceProtocol` function, eg:

```swift
override func getWorkspaceProtocol() -> any WorkspaceProtocol {
    return MyWorkspaceProtocol()
}
```

### Creating an OutlineView
1. Create a subclass of `OutlineElement` to hold the information in each view in the OutlineView
2. Create a subclass of the `StandardTableViewCell`
3. Create a subclass of `OutlineViewController`. You **NEED** to override the following functions:
  - `loadContent()`, which returns an array of an `OutlineElement`
  - `outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any)`, 
  which returns an NSView for a given element. This will be your custom instance of `StandardTableViewCell`.
4. Use `OutlineView` if you plan to use your custom outline view within SwiftUI.

See `TestElement`, `TestOutlineViewController`, and `TestTableViewCell` 
for an example in [the example repo](https://github.com/KaiTheRedNinja/minimalMacOSApp.git)

### Adding extra toolbar elements
Override the `toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]`, 
`toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]`, and
`open func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?` functions in your `MainWindowController` subclass. 
Extend `NSToolbarItem.Identifier` to add custom identifiers. See the [apple developer documentation](https://developer.apple.com/documentation/appkit/nstoolbar/) for more details

Remember that you can use `defaultLeadingItems()` and `defaultTrailingItems` to get the default leading and trailing items, which are the toolbar items
for the sidebar show/hide buttons. You can also use the `builtinDefaultToolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem?` function to get the `NSToolbarItem` for a given identifier, or nil if it is not a toolbar item that MainWindowController implements.

