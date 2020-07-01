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

class MenuBar {
  final List<MenuItem> menuItems;
  ///The thickness of the MenuBar.  
  final double thickness;
  final BoxDecoration decoration;
  final Widget _divider;

  MenuBar({this.menuItems, this.thickness = 36, this.decoration, Widget divider})
      : _divider = divider ??
            Container(
              width: 1,
              color: Colors.black,
            );
}

class _MenuBar extends StatefulWidget {
  final GlobalKey menuKey;
  final MenuBar menuBar;
  final Function dismiss;

  _MenuBar({Key key, this.dismiss, this.menuBar, this.menuKey}) : super(key: key);

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
              dismiss: widget.dismiss,
            ))
        .toList();

    return ClipRRect(
      child: Container(
        decoration: widget.menuBar.decoration,
        height: widget.menuBar.thickness,
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          key: widget.menuKey,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: addDividers<Widget>(widgetItems, widget.menuBar._divider),
        ),
      ),
    );
  }
}
