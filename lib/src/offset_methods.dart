part of 'menu.dart';

Offset getOffsetByAlignment(Rect rect, MenuAlignment alignment) {
    var newOffset;
    switch (alignment) {
      case MenuAlignment.topLeft:
        newOffset = rect.topLeft;
        break;
      case MenuAlignment.topCenter:
        newOffset = rect.topCenter;
        break;
      case MenuAlignment.topRight:
        newOffset = rect.topRight;
        break;
      case MenuAlignment.centerLeft:
        newOffset = rect.centerLeft;
        break;
      case MenuAlignment.center:
        newOffset = rect.center;
        break;
      case MenuAlignment.centerRight:
        newOffset = rect.centerRight;
        break;
      case MenuAlignment.bottomLeft:
        newOffset = rect.bottomLeft;
        break;
      case MenuAlignment.bottomCenter:
        newOffset = rect.bottomCenter;
        break;
      case MenuAlignment.bottomRight:
        newOffset = rect.bottomRight;
        break;
      default:
        newOffset = Offset.zero;
    }
    return newOffset;
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

