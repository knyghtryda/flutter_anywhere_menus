part of 'menu.dart';

List<T> addDividers<T>(List<T> items, T divider) {
  if (items == null) return null;
  var finalItems = <T>[];
  for (var i = 0; i < items.length; i++) {
    finalItems.add(items[i]);
    if (i + 1 != items.length) finalItems.add(divider);
  }
  return finalItems;
}

/// [MenuBar] holds the parameters for drawing the menu
class MenuBar {
  /// A list of the items of the menu
  final List<MenuItem> menuItems;
  /// The thickness of the MenuBar.  
  final double maxThickness;
  /// This sets the paddings for all [MenuItem] in this menu.  Note that the [MenuItem] can override this
  /// if it specifies its own padding
  final EdgeInsets itemPadding;
  /// Do you want to draw a divider?
  final bool drawDivider;
  final Color backgroundColor;
  final double elevation;
  /// This sets a border radius for the menu
  final BorderRadiusGeometry borderRadius;
  final Widget _divider;

  MenuBar({
    this.menuItems,
    this.maxThickness = 36,
    Widget dividerWidget,
    this.itemPadding = const EdgeInsets.all(4),
    this.drawDivider = true,
    Color backgroundColor,
    this.elevation = 4,
    BorderRadiusGeometry borderRadius,
  })  : this.backgroundColor = backgroundColor ?? Colors.grey[200],
        this._divider =
            dividerWidget ?? Container(width: 1, color: Colors.white),
        this.borderRadius = borderRadius ?? BorderRadius.circular(16);
}

class _MenuBar extends StatefulWidget {
  final GlobalKey menuKey;
  final MenuBar menuBar;
  final Function dismiss;

  _MenuBar({Key key, this.dismiss, this.menuBar, this.menuKey})
      : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<_MenuBar> {
  @override
  Widget build(BuildContext context) {
    final menuItems = widget.menuBar.menuItems ??
        [MenuItem(child: Text('Menu 1')), MenuItem(child: Text('Menu 2'))];
    final widgetItems = menuItems
        .map((item) => _MenuItem(
              menuItem: item,
              itemPadding: widget.menuBar.itemPadding,
              dismiss: widget.dismiss,
            ))
        .toList();
    // Container sets the thickness of the menu.
    // TODO: modify this to allow for vertical menus
    return Container(
      constraints: BoxConstraints(maxHeight: widget.menuBar.maxThickness),
      // height: widget.menuBar.thickness,
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width,
      //Current location of the the menu decoration.  Material should probably exist here
      child: Material(
        color: widget.menuBar.backgroundColor,
        elevation: widget.menuBar.elevation,
        borderRadius: widget.menuBar.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: widget.menuBar.drawDivider
            ? ListView.separated(
                key: widget.menuKey,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) => widgetItems[index],
                separatorBuilder: (context, index) => widget.menuBar._divider,
                itemCount: widgetItems.length,
              )
            : ListView(
                key: widget.menuKey,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: widgetItems,
              ),
      ),
    );
  }
}
