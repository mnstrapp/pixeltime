import 'package:flutter/material.dart';

import 'theme.dart';

class UITabBarItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isSelected;

  const UITabBarItem({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
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
        ],
      ),
    );
  }
}

class UITabBar extends StatelessWidget {
  final List<UITabBarItem> children;
  final Function(int) onPressed;
  final int? selectedIndex;

  const UITabBar({
    super.key,
    this.children = const [],
    required this.onPressed,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      padding: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: BaseColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: BaseTheme.borderRadiusSmall,
        children: [
          ...children.map(
            (child) => InkWell(
              onTap: () => onPressed(children.indexOf(child)),
              child: child.copyWith(
                isSelected: selectedIndex == children.indexOf(child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
