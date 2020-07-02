import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'enums.dart';

part 'menu_item.dart';
part 'menu_bar.dart';

///[Menu] is the what contains both the widget you want to draw a menu for and the menu object itself, called [MenuBar]
class Menu extends StatefulWidget {
  final Widget child;

  /// A [MenuBar] which contains all of the info for rendering the Menu
  final MenuBar menuBar;

  /// This will draw the menu where you tap/click on the child widget instead of at a predefined position
  final bool menuOverTap;

  /// This sets the alignment/orientation where the menu is to be drawn.
  ///
  /// For example, `menuAlignmentOnChild: Alignment.topCenter` means that the menu will be drawn aligned to the topCenter of the child widget
  /// The default is to draw the menu outside of the child widget, so that for `Alignment.topCenter` the bottom of the menu and the top of the
  /// child will be touching
  final MenuAlignment menuAlignmentOnChild;

  /// [MenuPosition] is an enum that specifies whether to draw the menu outside or inside of the child widget.  By default it is set to outside.
  final MenuPosition position;

  /// This is an x,y offset that will applied after the menu has been aligned.  This allows you to push the toward or away from the child
  /// or shift it side to side as needed.
  final Offset offset;

  /// This sets what type of tap (onTap, onDoubleTap, etc) this menu will respond to.
  final TapType tapType;

  /// This will clamp the position so that the menu always renders on the screen.  Default is `true`.
  final bool forceOnscreen;

  Menu({
    Key key,
    this.child,
    this.menuBar,
    this.menuOverTap = false,
    this.menuAlignmentOnChild = MenuAlignment.topCenter,
    this.position = MenuPosition.outside,
    this.offset = Offset.zero,
    this.tapType = TapType.tap,
    this.forceOnscreen = true,
  }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey key = GlobalKey();
  OverlayEntry itemEntry;
  bool showMenu = false;
  // ignore: prefer_final_fields
  static List<OverlayEntry> _overlays = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: widget.tapType == TapType.tap && !widget.menuOverTap
          ? buildMenu
          : null,
      onDoubleTap: widget.tapType == TapType.doubleTap ? buildMenu : null,
      onSecondaryTap:
          (widget.tapType == TapType.secondaryTap) && !widget.menuOverTap
              ? buildMenu
              : null,
      onLongPress: widget.tapType == TapType.longPress ? buildMenu : null,
      onTapUp: widget.tapType == TapType.tap && widget.menuOverTap
          ? (details) {
              buildMenu(tapOffset: details.globalPosition);
            }
          : null,
      onSecondaryTapUp:
          widget.tapType == TapType.secondaryTap && widget.menuOverTap
              ? (details) {
                  buildMenu(tapOffset: details.globalPosition);
                }
              : null,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }

  MenuAlignment childAlignmentOnMenu(MenuAlignment alignment) {
    switch (alignment) {
      case MenuAlignment.topLeft:
        return MenuAlignment.bottomRight;
        break;
      case MenuAlignment.topCenter:
        return MenuAlignment.bottomCenter;
        break;
      case MenuAlignment.topRight:
        return MenuAlignment.bottomLeft;
        break;
      case MenuAlignment.centerLeft:
        return MenuAlignment.centerRight;
        break;
      case MenuAlignment.center:
        return MenuAlignment.center;
        break;
      case MenuAlignment.centerRight:
        return MenuAlignment.centerLeft;
        break;
      case MenuAlignment.bottomLeft:
        return MenuAlignment.topRight;
        break;
      case MenuAlignment.bottomCenter:
        return MenuAlignment.topCenter;
        break;
      case MenuAlignment.bottomRight:
        return MenuAlignment.topLeft;
        break;
      default:
        return MenuAlignment.bottomCenter;
    }
  }

  Rect findGlobalRect(GlobalKey key, {childAlignBy = MenuAlignment.topLeft}) {
    RenderBox renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) {
      return null;
    }

    var globalOffset = renderObject?.localToGlobal(Offset.zero);

    if (globalOffset == null) {
      return null;
    }

    var bounds = renderObject.paintBounds;
    Offset alignmentOffset;

    switch (childAlignBy) {
      case MenuAlignment.topLeft:
        alignmentOffset = bounds.topLeft;
        break;
      case MenuAlignment.topCenter:
        alignmentOffset = bounds.topCenter;
        break;
      case MenuAlignment.topRight:
        alignmentOffset = bounds.topRight;
        break;
      case MenuAlignment.centerLeft:
        alignmentOffset = bounds.centerLeft;
        break;
      case MenuAlignment.center:
        alignmentOffset = bounds.center;
        break;
      case MenuAlignment.centerRight:
        alignmentOffset = bounds.centerRight;
        break;
      case MenuAlignment.bottomLeft:
        alignmentOffset = bounds.bottomLeft;
        break;
      case MenuAlignment.bottomCenter:
        alignmentOffset = bounds.bottomCenter;
        break;
      case MenuAlignment.bottomRight:
        alignmentOffset = bounds.bottomRight;
        break;
      default:
        alignmentOffset = Offset.zero;
    }

    var finalOffset = globalOffset + alignmentOffset;
    bounds = bounds.translate(finalOffset.dx, finalOffset.dy);
    return bounds;
  }

  void buildMenu({Offset tapOffset}) {
    MenuAlignment _childAlignmentOnMenu;
    Offset globalOffset;
    if (tapOffset != null) {
      globalOffset = tapOffset;
      _childAlignmentOnMenu = MenuAlignment.center;
    } else {
      final rect =
          findGlobalRect(key, childAlignBy: widget.menuAlignmentOnChild);
      globalOffset = Offset(rect.left, rect.top);
      _childAlignmentOnMenu = (widget.position == MenuPosition.inside
          ? widget.menuAlignmentOnChild
          : childAlignmentOnMenu(widget.menuAlignmentOnChild));
    }
    itemEntry = OverlayEntry(
      builder: (BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          dismiss();
        },
        child: _MenuWidget(
          menuBar: widget.menuBar ?? MenuBar(),
          globalOffset: globalOffset,
          menuOffset: widget.offset,
          alignment: _childAlignmentOnMenu,
          dismiss: dismiss,
          forceOnscreen: widget.forceOnscreen,
        ),
      ),
    );

    Overlay.of(context).insert(itemEntry);
    _overlays.add(itemEntry);
  }

  void dismiss() {
    _overlays.forEach((element) {
      element?.remove();
    });
    _overlays.clear();
  }
}

class _MenuWidget extends StatefulWidget {
  final Offset globalOffset;
  final Offset menuOffset;
  final MenuBar menuBar;
  final MenuAlignment alignment;
  final bool forceOnscreen;
  final Function dismiss;

  const _MenuWidget({
    Key key,
    this.globalOffset,
    this.dismiss,
    this.alignment,
    this.menuOffset,
    this.menuBar,
    this.forceOnscreen,
  }) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<_MenuWidget>
    with AfterLayoutMixin<_MenuWidget> {
  Offset _offset = Offset.zero;
  final GlobalKey menuKey = GlobalKey();
  bool showMenu = false;
  Size _size = Size(0, 0);

  @override
  void initState() {
    _offset = widget.globalOffset - widget.menuOffset;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox renderObject = menuKey.currentContext?.findRenderObject();
    _size = renderObject.size;
    var newOffset;
    switch (widget.alignment) {
      case MenuAlignment.topLeft:
        newOffset = _size.topLeft(Offset.zero);
        break;
      case MenuAlignment.topCenter:
        newOffset = _size.topCenter(Offset.zero);
        break;
      case MenuAlignment.topRight:
        newOffset = _size.topRight(Offset.zero);
        break;
      case MenuAlignment.centerLeft:
        newOffset = _size.centerLeft(Offset.zero);
        break;
      case MenuAlignment.center:
        newOffset = _size.center(Offset.zero);
        break;
      case MenuAlignment.centerRight:
        newOffset = _size.centerRight(Offset.zero);
        break;
      case MenuAlignment.bottomLeft:
        newOffset = _size.bottomLeft(Offset.zero);
        break;
      case MenuAlignment.bottomCenter:
        newOffset = _size.bottomCenter(Offset.zero);
        break;
      case MenuAlignment.bottomRight:
        newOffset = _size.bottomRight(Offset.zero);
        break;
      default:
        newOffset = Offset.zero;
    }
    setState(() {
      _offset -= newOffset;
      showMenu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //Opacity makes the widget invisible until it is rendered and moved into position
    return Opacity(
      opacity: showMenu ? 1.0 : 0,
      //This padding is what shifts the menu on global coordinates, with 0,0 in the upper left
      child: Stack(
        //Uncertain function for FittedBox, but it is necessary for things to work
        children: [
          Positioned(
            //Clamp is necessary to prevent a negative padding
            left: widget.forceOnscreen
                ? _offset.dx.clamp(0, size.width - _size.width).toDouble()
                : _offset.dx,
            top: widget.forceOnscreen
                ? _offset.dy.clamp(0, size.height - _size.height).toDouble()
                : _offset.dy,
            child: FittedBox(
              fit: BoxFit.none,
              alignment: Alignment.topLeft,
              child: _MenuBar(
                menuKey: menuKey,
                menuBar: widget.menuBar,
                dismiss: widget.dismiss,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
