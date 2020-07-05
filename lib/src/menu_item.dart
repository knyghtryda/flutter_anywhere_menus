part of 'menu.dart';

/// This sets each individual cell of the menu
class MenuItem {
  final Widget child;
  final Color backgroundColor;
  final Color _splashColor;
  final EdgeInsets padding;
  final Function onTap;
  final Function onLongPress;

  const MenuItem(
      {this.onTap,
      this.onLongPress,
      this.child,
      this.backgroundColor,
      Color splashColor,
      this.padding})
      : _splashColor = splashColor ?? Colors.blueGrey;
}

class _MenuItem extends StatefulWidget {
  final MenuItem menuItem;
  final EdgeInsets itemPadding;
  final Function dismiss;

  const _MenuItem({
    Key key,
    this.dismiss,
    this.menuItem,
    this.itemPadding,
  }) : super(key: key);
  @override
  __MenuItemState createState() => __MenuItemState();
}

class __MenuItemState extends State<_MenuItem> {
  @override
  Widget build(BuildContext context) {
    //InkWell is needed to add splash to tap events
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (widget.menuItem.onTap != null) widget.menuItem.onTap();
          //TODO: figure out what to do with dismissing after tap.  Maybe just leave as is?
          //widget.dismiss();
        },
        onLongPress: () {
          if (widget.menuItem.onLongPress != null) {
            widget.menuItem.onLongPress();
          }
        },
        splashColor: widget.menuItem._splashColor,
        child: Center(
          child: Padding(
            padding: widget.menuItem.padding ??
                widget.itemPadding ??
                EdgeInsets.all(0),
            child: widget.menuItem.child,
          ),
        ),
      ),
    );
  }
}
