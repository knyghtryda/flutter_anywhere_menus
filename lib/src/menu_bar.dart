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

/// This holds the parameters for drawing the menu
class MenuBar {
  /// A list of the items of the menu
  final List<MenuItem> menuItems;

  /// The thickness of the MenuBar.
  ///
  /// A thickess is required.  Default is 36.
  final double maxThickness;

  /// Menu orientation (vertical, horizontal)
  final MenuOrientation orientation;

  /// This sets the paddings for all [MenuItem] in this menu.  Note that the [MenuItem] can override this
  /// if it specifies its own padding
  final EdgeInsets itemPadding;

  /// Do you want to draw a divider?
  final bool drawDivider;
  final Color backgroundColor;
  final double elevation;

  /// This sets a border radius for the menu when [borderStyle] is set to [MenuBorderStyle.rounded]
  final BorderRadiusGeometry borderRadius;
  final Widget _divider;

  /// This draws the arrow/triangle pointing the menu to the parent
  final bool drawArrow;

  /// This selects between straight, rounded, and pill styles.
  ///
  /// Pill means that [borderRadius] is calculated automatically to insure that both ends are fully rounded.
  final MenuBorderStyle borderStyle;

  final bool fadeIn;

  final Duration fadeInDuration;

  MenuBar({
    this.menuItems = const [
      MenuItem(child: Text('Menu 1')),
      MenuItem(child: Text('Menu 2'))
    ],
    this.maxThickness = 36,
    this.orientation = MenuOrientation.horizontal,
    Widget dividerWidget,
    this.itemPadding = const EdgeInsets.all(4),
    this.drawDivider = true,
    Color backgroundColor,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.drawArrow = false,
    this.borderStyle = MenuBorderStyle.pill,
    this.fadeIn = false,
    this.fadeInDuration = const Duration(milliseconds: 250),
    // ignore: unnecessary_this
  })  : this.backgroundColor = backgroundColor ?? Colors.grey[200],
        // ignore: unnecessary_this
        this._divider = dividerWidget ??
            Container(
                width: orientation == MenuOrientation.horizontal ? 1 : null,
                height: orientation == MenuOrientation.vertical ? 1 : null,
                color: Colors.white);
}

class _MenuBar extends StatefulWidget {
  final GlobalKey menuKey;
  final MenuBar menuBar;
  final MenuAlignment menuAlignment;
  final Function dismiss;

  const _MenuBar(
      {Key key, this.dismiss, this.menuBar, this.menuAlignment, this.menuKey})
      : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<_MenuBar> {
  bool _show;
  @override
  Widget build(BuildContext context) {
    _show = !widget.menuBar.fadeIn;
    final menuItems = widget.menuBar.menuItems
        .map((item) => _MenuItem(
              menuItem: item,
              itemPadding: widget.menuBar.itemPadding,
              dismiss: widget.dismiss,
            ))
        .toList();
    // Container sets the thickness of the menu.
    return Container(
      constraints: BoxConstraints(
          maxHeight: widget.menuBar.orientation == MenuOrientation.horizontal
              ? widget.menuBar.maxThickness
              : double.infinity,
          maxWidth: widget.menuBar.orientation == MenuOrientation.vertical
              ? widget.menuBar.maxThickness
              : double.infinity),
      alignment: Alignment.topLeft,
      child: AnimatedOpacity(
        opacity: _show ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: Material(
          key: widget.menuKey,
          color: widget.menuBar.backgroundColor,
          elevation: widget.menuBar.elevation,
          borderRadius: widget.menuBar.borderStyle != MenuBorderStyle.pill
              ? widget.menuBar.borderStyle == MenuBorderStyle.straight
                  ? 0
                  : widget.menuBar.borderRadius
              : null,
          clipBehavior: Clip.antiAlias,
          shape: widget.menuBar.borderStyle == MenuBorderStyle.pill
              ? MenuBorder(
                  arrowAlignment: widget.menuAlignment,
                  drawArrow: widget.menuBar.drawArrow)
              : null,
          child: widget.menuBar.orientation == MenuOrientation.horizontal
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.menuBar.drawDivider
                      ? addDividers(menuItems, widget.menuBar._divider)
                      : menuItems,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.menuBar.drawDivider
                      ? addDividers(menuItems, widget.menuBar._divider)
                      : menuItems,
                ),
        ),
      ),
    );
  }
}

class MenuBorder extends ShapeBorder {
  final bool usePadding;
  final MenuAlignment arrowAlignment;
  final double radius;
  final double arrowSize;
  final bool drawArrow;

  const MenuBorder({
    this.arrowAlignment = MenuAlignment.bottomCenter,
    this.radius,
    this.arrowSize = 10,
    this.usePadding = true,
    this.drawArrow = false,
  });

  void trianglePathFromAlignment(
      {Path path,
      Rect rect,
      double size,
      double radius,
      MenuAlignment alignment}) {
    final arrowOffset = getOffsetByAlignment(rect, alignment);
    final cornerLength = radius ?? rect.height / 2;
    switch (alignment) {
      case MenuAlignment.topLeft:
        path
          ..moveTo(arrowOffset.dx, arrowOffset.dy + cornerLength)
          ..lineTo(arrowOffset.dx - size, arrowOffset.dy - size)
          ..lineTo(arrowOffset.dx + cornerLength, arrowOffset.dy);
        break;
      case MenuAlignment.topCenter:
        path
          ..moveTo(arrowOffset.dx - size, arrowOffset.dy)
          ..lineTo(arrowOffset.dx, arrowOffset.dy - size)
          ..lineTo(arrowOffset.dx + size, arrowOffset.dy);
        break;
      case MenuAlignment.topRight:
        path
          ..moveTo(arrowOffset.dx - cornerLength, arrowOffset.dy)
          ..lineTo(arrowOffset.dx + size, arrowOffset.dy - size)
          ..lineTo(arrowOffset.dx, arrowOffset.dy + cornerLength);
        break;
      case MenuAlignment.centerRight:
        path
          ..moveTo(arrowOffset.dx, arrowOffset.dy - size)
          ..lineTo(arrowOffset.dx + size, arrowOffset.dy)
          ..lineTo(arrowOffset.dx, arrowOffset.dy + size);
        break;
      case MenuAlignment.bottomRight:
        path
          ..moveTo(arrowOffset.dx, arrowOffset.dy - cornerLength)
          ..lineTo(arrowOffset.dx + size, arrowOffset.dy + size)
          ..lineTo(arrowOffset.dx - cornerLength, arrowOffset.dy);
        break;
      case MenuAlignment.bottomCenter:
        path
          ..moveTo(arrowOffset.dx + size, arrowOffset.dy)
          ..lineTo(arrowOffset.dx, arrowOffset.dy + size)
          ..lineTo(arrowOffset.dx - size, arrowOffset.dy);
        break;
      case MenuAlignment.bottomLeft:
        path
          ..moveTo(arrowOffset.dx + cornerLength, arrowOffset.dy)
          ..lineTo(arrowOffset.dx - size, arrowOffset.dy + size)
          ..lineTo(arrowOffset.dx, arrowOffset.dy - cornerLength);
        break;
      case MenuAlignment.centerLeft:
        path
          ..moveTo(arrowOffset.dx, arrowOffset.dy + size)
          ..lineTo(arrowOffset.dx - size, arrowOffset.dy)
          ..lineTo(arrowOffset.dx, arrowOffset.dy - size);
        break;
      default:
    }
  }

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    var path = Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)));
    if (drawArrow) {
      trianglePathFromAlignment(
          path: path,
          rect: rect,
          size: arrowSize,
          radius: radius,
          alignment: arrowAlignment);
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
