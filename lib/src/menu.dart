import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'enums.dart';

part 'menu_item.dart';
part 'menu_bar.dart';

/// This is the what contains both the widget you want to draw and the [MenuBar]
class Menu extends StatefulWidget {
  final Widget child;

  /// A [MenuBar] which contains all of the info for rendering the Menu
  final MenuBar menuBar;

  /// This will draw the menu where you tap/click on the child widget instead of at a predefined position  Default is `false`
  final bool menuOverTap;

  /// This sets the alignment/orientation where the menu is to be drawn.
  ///
  /// For example, `menuAlignmentOnChild: Alignment.topCenter` means that the menu will be drawn aligned to the topCenter of the child widget
  /// The default is to draw the menu outside of the child widget, so that for `Alignment.topCenter` the bottom of the menu and the top of the
  /// child will be touching
  final MenuAlignment menuAlignmentOnChild;

  /// This is an enum that specifies whether to draw the menu outside or inside of the child widget.  By default it is set to outside.
  final MenuPosition position;

  /// This is an x,y offset that will applied after the menu has been aligned.
  ///
  /// This allows you to push the toward or away from the child or shift it side to side as needed.
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
      onSecondaryTapDown: (details) {
        if (widget.tapType == TapType.secondaryTap && !widget.menuOverTap) {
          return buildMenu;
        }
        return null;
      },
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
    Offset rectCenterOffset;
    if (tapOffset != null) {
      globalOffset = tapOffset;
      _childAlignmentOnMenu = MenuAlignment.center;
    } else {
      final rect =
          findGlobalRect(key, childAlignBy: widget.menuAlignmentOnChild);
      globalOffset = Offset(rect.left, rect.top);
      if (widget.position == MenuPosition.inside) {
        _childAlignmentOnMenu = widget.menuAlignmentOnChild;
      } else {
        _childAlignmentOnMenu =
            childAlignmentOnMenu(widget.menuAlignmentOnChild);
      }
    }
    final rectCenter = findGlobalRect(key, childAlignBy: MenuAlignment.center);
    rectCenterOffset = Offset(rectCenter.left, rectCenter.top);
    itemEntry = OverlayEntry(
      builder: (BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          dismiss();
        },
        child: _MenuWidget(
          menuBar: widget.menuBar ?? MenuBar(),
          globalOffset: globalOffset,
          centerOffset: rectCenterOffset,
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

  /// dismiss is passed along so that any widget drawn by this menu can call it and dismiss the whole tree and close the menu
  void dismiss() {
    _overlays.forEach((element) {
      element?.remove();
    });
    _overlays.clear();
  }
}

class _MenuWidget extends StatefulWidget {
  final Offset globalOffset;
  final Offset centerOffset;
  final Offset menuOffset;
  final MenuBar menuBar;
  final MenuAlignment alignment;
  final bool forceOnscreen;
  final Function dismiss;

  const _MenuWidget({
    Key key,
    this.globalOffset,
    this.centerOffset,
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
  Size menuSize = Size(0, 0);

  @override
  void initState() {
    _offset = widget.globalOffset - widget.menuOffset;
    super.initState();
  }

  Offset getNewOffset(Size size, MenuAlignment alignment) {
    var newOffset;
    switch (alignment) {
      case MenuAlignment.topLeft:
        newOffset = size.topLeft(Offset.zero);
        break;
      case MenuAlignment.topCenter:
        newOffset = size.topCenter(Offset.zero);
        break;
      case MenuAlignment.topRight:
        newOffset = size.topRight(Offset.zero);
        break;
      case MenuAlignment.centerLeft:
        newOffset = size.centerLeft(Offset.zero);
        break;
      case MenuAlignment.center:
        newOffset = size.center(Offset.zero);
        break;
      case MenuAlignment.centerRight:
        newOffset = size.centerRight(Offset.zero);
        break;
      case MenuAlignment.bottomLeft:
        newOffset = size.bottomLeft(Offset.zero);
        break;
      case MenuAlignment.bottomCenter:
        newOffset = size.bottomCenter(Offset.zero);
        break;
      case MenuAlignment.bottomRight:
        newOffset = size.bottomRight(Offset.zero);
        break;
      default:
        newOffset = Offset.zero;
    }
    return newOffset;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    RenderBox renderObject = menuKey.currentContext?.findRenderObject();
    menuSize = renderObject.size;
    var newOffset = getNewOffset(menuSize, widget.alignment);
    _offset = widget.globalOffset - widget.menuOffset - newOffset;
    setState(() {
      showMenu = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //Opacity makes the widget invisible until it is rendered and moved into position
    return Opacity(
      opacity: showMenu ? 1.0 : 0,
      //This Stack and positioned is what shifts the menu on global coordinates, with 0,0 in the upper left
      child: Stack(
        children: [
          Positioned(
            left: widget.forceOnscreen
                ? _offset.dx.clamp(0, size.width - menuSize.width).toDouble()
                : _offset.dx,
            top: widget.forceOnscreen
                ? _offset.dy.clamp(0, size.height - menuSize.height).toDouble()
                : _offset.dy,
            //Uncertain function for FittedBox, but it is necessary for things to work
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
