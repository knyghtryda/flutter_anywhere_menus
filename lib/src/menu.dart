import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'enums.dart';

part 'menu_item.dart';
part 'menu_bar.dart';
part 'offset_methods.dart';

/// This is the what contains both the widget you want to draw and the [MenuBar]
class Menu extends StatefulWidget {
  final Widget child;

  /// This contains all of the info for rendering the Menu
  final MenuBar menuBar;

  /// This will draw the menu where you tap/click on the child widget instead of at a predefined alignment.  Default is `false`
  /// 
  /// Setting this `true` means MenuBar will ignore all alignment paramenters.
  final bool menuOverTap;

  /// This sets the alignment/orientation where the menu is to be drawn.
  ///
  /// For example, `menuAlignmentOnChild: Alignment.topCenter` means that the menu will be drawn aligned to the topCenter of the child widget
  /// The default is to draw the menu outside of the child widget, so that for `Alignment.topCenter` the bottom of the menu and the top of the
  /// child will be touching
  final MenuAlignment menuAlignmentOnChild;

  /// This specifies whether to draw the menu outside or inside of the child widget.  By default it is set to outside.
  final MenuPosition position;

  /// This is an x,y offset that will applied after the menu has been aligned.
  ///
  /// This allows you to fine-tune the menu position.
  final Offset offset;

  /// This sets what type of tap (onTap, onDoubleTap, etc) this menu will respond to.
  final TapType tapType;

  const Menu({
    Key key,
    this.child,
    this.menuBar,
    this.menuOverTap = false,
    this.menuAlignmentOnChild = MenuAlignment.topCenter,
    this.position = MenuPosition.outside,
    this.offset = Offset.zero,
    this.tapType = TapType.tap,
  }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey key = GlobalKey();
  OverlayEntry itemEntry;
  final layerLink = LayerLink();

  bool showMenu = false;
  // ignore: prefer_final_fields
  static List<OverlayEntry> _overlays = [];
  final GlobalKey sizeKey = GlobalKey();

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
              buildMenu(tapOffset: details.localPosition);
            }
          : null,
      onSecondaryTapUp:
          widget.tapType == TapType.secondaryTap && widget.menuOverTap
              ? (details) {
                  buildMenu(tapOffset: details.localPosition);
                }
              : null,
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CompositedTransformTarget(link: layerLink, child: widget.child),
          //Renders a copy of the menu offstage in order take measurements
          Offstage(
            offstage: true,
            child: _MenuBar(
              menuKey: sizeKey,
              menuBar: widget.menuBar,
              menuAlignment: childAlignmentOnMenu(widget.menuAlignmentOnChild),
            ),
          ),
        ],
      ),
    );
  }

  void buildMenu({Offset tapOffset}) {
    MenuAlignment _childAlignmentOnMenu;
    //Computes the child alignment point
    if (tapOffset != null) {
      _childAlignmentOnMenu = MenuAlignment.center;
    } else {
      if (widget.position == MenuPosition.inside) {
        _childAlignmentOnMenu = widget.menuAlignmentOnChild;
      } else {
        _childAlignmentOnMenu =
            childAlignmentOnMenu(widget.menuAlignmentOnChild);
      }
    }
    // Gets the size of the parent
    RenderBox renderObject = key.currentContext?.findRenderObject();
    final bounds = renderObject.paintBounds;

    // Gets the size of the menu
    RenderBox menuObject = sizeKey.currentContext?.findRenderObject();
    final menuBounds = menuObject.paintBounds;
    Offset childOffset;

    // Computes the offset for the child in relation to the parent
    if (tapOffset != null) {
      childOffset = tapOffset -
          getOffsetByAlignment(menuBounds, MenuAlignment.center) -
          widget.offset;
    } else {
      var newOffset = getOffsetByAlignment(menuBounds, _childAlignmentOnMenu);
      childOffset = -(widget.offset + newOffset);
    }

    itemEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => dismiss(),
        child: Stack(children: [
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: getOffsetByAlignment(
                    bounds,
                    widget.menuOverTap
                        ? MenuAlignment.topLeft
                        : widget.menuAlignmentOnChild) +
                childOffset,
            child: _MenuBar(
              menuBar: widget.menuBar,
              dismiss: dismiss,
              menuAlignment: childAlignmentOnMenu(widget.menuAlignmentOnChild),
            ),
          ),
        ]),
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
