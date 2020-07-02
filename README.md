# Flutter Anywhere Menus (FAM)
Menus, anywhere you want them!

## Usage

**Defaults**
```dart
import 'package:fam/menu.dart';

Menu(
  child: Container(
    width: 200,
    color: Colors.yellow,
    height: 100,
    child: Text("Press me"),
  ),
  menuBar: MenuBar()
);
```

## Roadmap
- [ ] Vertical menus
- [ ] Fixed screen position menus
- [ ] Animations

## Background
Why FAM?  The short answer is... [yak shaving][1].  I needed a menu for a project that would pop up above a widget when I clicked on it.  Simple right?  Yeah... no.  There were a few more requirements that made it a far more interesting problem.
1.  The menu needs to be very customizable
2.  The menu needs the ability to have sub-menus **OR** sub-widgets
3.  The menu (and all sub-menus and sub-widgets) needs to be a drawn above all other widgets
4.  And this was the doozy... the menu needs to be positionable *RELATIVE* to its parent widget, and all sub-menus and sub-widgets need to be relative positioned to their parent

That last requirement took me down the rabbit hole of Flutter widget positioning and long story short, Flutter is one of a few (maybe the only?) rendering/UI languages I've used that simply cannot do relative positioning out of the box (pun intended).  See, the box is what traps you.  You can `Column()` and `Row()` all day long but you're still trapped in box.  What I want is the equivalent of `widget1.alignTo(widget2, fromAlignment: Alignment.topCenter, toAlignment: Alignment.bottomCenter)` so that I can setup a widget and then just stick it on to another widget.  A man can dream right?

Maybe `Stack()` and `Align()`? 
**HA!**  Still stuck in that box, and still no way to define a solid widget to widget positioning.

I want my menu outside of the box *MAN!*  And without knowing the sizes of the boxes before rendering, good luck trying to accurately position a menu over (or under, or next to) its intended target widget.  So what does FAM do?  

It... cheats.  

FAM still doesn't know about the properties of the menu before hand, BUT what it can do is render the menu invisibly as an overlay, examine its size, then move it to where it needs to be.  The result is that I can now define an absolute relationship between relevant points on a widget (say, tying the `bottomCenter` of one widget to the `topCenter` of another) without either widget having any relationship, and without any restrictions on how I draw either widget, while making sure that whatever crazy alignments I do won't mess up the positioning or size of my original widget.  

And this is a being done with overlays 😃 and...

`EdgeInsets` padding 😑 

**UGH.**  

**THE BOX STILL WINS!!!**

OK.  It ain't pretty, but the results do speak for themselves.  Hope at least some of you can make use of this, and maybe Flutter will one day have relational positioning like any sensible rendering language.

## Credits
This was originally a fork of https://github.com/CaiJingLong/flutter_long_tap_menu that outgrew most of the original code.  

[1]:https://en.wiktionary.org/wiki/yak_shaving 
