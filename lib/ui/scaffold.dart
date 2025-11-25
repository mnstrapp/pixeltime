import 'package:flutter/material.dart';

import '../bitmap_projects/new.dart';
import 'menu_bar.dart';
import 'overlay_content.dart';

class UIScaffold extends StatefulWidget {
  final Widget child;
  final bool showLogo;
  final List<UIMenuBarItem> menuBarItems;

  const UIScaffold({
    super.key,
    required this.child,
    this.showLogo = false,
    this.menuBarItems = const [],
  });

  @override
  State<UIScaffold> createState() => UIScaffoldState();

  static UIScaffoldState of(BuildContext context) {
    UIScaffoldState? state = context.findAncestorStateOfType<UIScaffoldState>();
    if (state == null) {
      throw Exception('UIScaffold not found in context');
    }
    return state;
  }
}

class UIScaffoldState extends State<UIScaffold> {
  final _overlayController = OverlayPortalController();
  Widget? _overlayContent;

  void showOverlay(Widget overlayContent) {
    setState(() {
      _overlayContent = OverlayContent(
        onClose: hideOverlay,
        child: overlayContent,
      );
    });
    _overlayController.show();
  }

  void hideOverlay() {
    setState(() {
      _overlayContent = null;
    });
    _overlayController.hide();
  }

  List<UIMenuBarItem> _buildMenuBarItems() {
    final menuBarItems = <UIMenuBarItem>[
      UIMenuBarItem(
        label: 'Projects',
        children: [
          UIMenuBarItem(
            label: 'New',
            icon: Icons.add,
            onPressed: () =>
                showOverlay(NewBitmapProjectOverlay(onClose: hideOverlay)),
          ),
          UIMenuBarItem(label: 'Open', icon: Icons.open_in_new),
        ],
      ),
      ...widget.menuBarItems,
      UIMenuBarItem(
        label: 'Help',
        children: [
          UIMenuBarItem(label: 'About', icon: Icons.info),
        ],
      ),
    ];
    return menuBarItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          if (widget.showLogo)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/loading_figure.png',
                  width: 256,
                  height: 256,
                ),
              ),
            ),
          OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (context) => _overlayContent!,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              UIMenuBar(children: _buildMenuBarItems()),
              Expanded(child: widget.child),
            ],
          ),
        ],
      ),
    );
  }
}
