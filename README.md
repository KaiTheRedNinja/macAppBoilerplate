# minimalMacOSApp
Boilerplate for an Xcode-like macOS app UI.

Majority of behaviour and code extracted from AuroraEditor.

## Usage

### Adding extra toolbar elements
Modify the `MainWindowController` `NSToolbarDelegate` extension.

DO NOT modify the first and last two elements of `toolbarDefaultItemIdentifiers` as they are
required for sidebar show/hide behaviour

### Modifying the Navigator Sidebar tabs
Create the categories in the NavigatorModeSelectModel by adding a `SidebarDockIcon` 
into the `icons` array. The id is an integer that will be used later.

```swift
.init(imageName: "symbolName", title: "hoverTitle", id: 0)
``` 

Then, Add the view to the `NavigatorSidebar` View. 
Add an extra case to the `selection` switch statement (the number you use is the `id`
of your `SidebarDockIcon`). Put your view there, and it will be visible when that tab is
selected.

### Creating new tab types
To create a tab type, create a new case in the `TabBarItemID`.

To store data for the tab type, create a class that conforms to `TabBarItemRepresentable`.

To open a new tab, use the `openTab` function of the `TabManager` shared instance. 
Similarly, use the `closeTab` function to close your tab.

See the `test` case and the `TestElement` class as an example.

### Creating an OutlineView
1. Create a subclass of `OutlineElement` to hold the information in each view in the OutlineView
2. Create a subclass of the `StandardTableViewCell`
3. Create a subclass of `OutlineViewController`. You **NEED** to override the following functions:
  - `loadContent()`, which returns an array of an `OutlineElement`
  - `outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any)`, 
  which returns an NSView for a given element. This will be your custom instance of `StandardTableViewCell`.
4. Use `OutlineView` if you plan to use your custom outline view within SwiftUI.

See `TestElement`, `TestOutlineViewController`, and `TestTableViewCell` for an example.
