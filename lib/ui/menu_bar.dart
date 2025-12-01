import 'package:flutter/material.dart';

import 'theme.dart';

class UIMenuBarItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final List<UIMenuBarItem> children;

  const UIMenuBarItem({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (children.isNotEmpty) {
      return SubmenuButton(
        menuChildren: children,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(BaseTheme.elevationSmall),
        ),
        child: Text(label),
      );
    }
    return MenuItemButton(
      leadingIcon: icon != null ? Icon(icon) : null,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(BaseTheme.elevationSmall),
      ),
      onPressed: onPressed,
      child: MenuAcceleratorLabel(label),
    );
  }
}

class UIMenuBar extends StatefulWidget {
  final List<UIMenuBarItem> children;
  final bool showBackButton;

  const UIMenuBar({
    super.key,
    this.children = const [],
    this.showBackButton = true,
  });

  @override
  State<UIMenuBar> createState() => _UIMenuBarState();
}

class _UIMenuBarState extends State<UIMenuBar> {
  bool _isExpanded = true;
  @override
  Widget build(BuildContext context) {
    List<Widget> menuBarChildren = [
      Image.asset('assets/pixeltime-logo.png', width: 40, height: 40),
      if (_isExpanded) ...widget.children.map((child) => child),
      _isExpanded
          ? MenuItemButton(
              trailingIcon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(BaseTheme.borderRadiusSmall),
                      bottomRight: Radius.circular(BaseTheme.borderRadiusSmall),
                    ),
                  ),
                ),
              ),
            )
          : MenuItemButton(
              trailingIcon: const Icon(Icons.keyboard_arrow_right),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(BaseTheme.borderRadiusSmall),
                      bottomRight: Radius.circular(BaseTheme.borderRadiusSmall),
                    ),
                  ),
                ),
              ),
            ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: MenuBar(
        style: MenuStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(BaseTheme.borderRadiusSmall),
                bottomRight: Radius.circular(BaseTheme.borderRadiusSmall),
              ),
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
        children: menuBarChildren,
      ),
    );
  }
}
