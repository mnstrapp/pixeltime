import 'package:flutter/material.dart';

import 'theme.dart';

class UITabBarItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onClosed;
  final bool isSelected;

  const UITabBarItem({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.onClosed,
    this.isSelected = false,
  });

  UITabBarItem copyWith({
    String? label,
    IconData? icon,
    VoidCallback? onPressed,
    VoidCallback? onClosed,
    bool? isSelected,
  }) => UITabBarItem(
    label: label ?? this.label,
    icon: icon ?? this.icon,
    onPressed: onPressed ?? this.onPressed,
    onClosed: onClosed ?? this.onClosed,
    isSelected: isSelected ?? this.isSelected,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected
            ? BaseColors.primaryInverseContainerColor
            : BaseColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: isSelected
                  ? BaseColors.primaryContainerColor
                  : BaseColors.primaryContainerContrastColor,
            ),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? BaseColors.primaryContainerColor
                  : BaseColors.primaryContainerContrastColor,
            ),
          ),
          if (onClosed != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                onTap: onClosed,
                child: Icon(
                  Icons.close,
                  size: BaseTheme.iconSizeSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class UITabBar extends StatelessWidget {
  final List<UITabBarItem> children;
  final Function(int) onPressed;
  final Function(int)? onClosed;
  final int? selectedIndex;

  const UITabBar({
    super.key,
    this.children = const [],
    required this.onPressed,
    this.onClosed,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: BaseColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          ...children.map(
            (child) => InkWell(
              onTap: () => onPressed(children.indexOf(child)),
              child: child.copyWith(
                isSelected: selectedIndex == children.indexOf(child),
                onClosed: () => onClosed?.call(children.indexOf(child)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
