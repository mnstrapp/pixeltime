import 'package:flutter/material.dart';

import 'theme.dart';

class OverlayContent extends StatelessWidget {
  final VoidCallback onClose;
  final Widget child;

  const OverlayContent({super.key, required this.onClose, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    double margin = BaseTheme.borderRadiusLarge * 3;
    if (size.width > BreakPoints.tabletBreakpoint) {
      margin = size.width < size.height
          ? size.width * 0.25
          : size.height * 0.25;
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(margin),
            padding: EdgeInsets.only(
              right: BaseTheme.borderRadiusSmall,
              left: BaseTheme.borderRadiusSmall,
            ),
            decoration: BoxDecoration(
              color: BaseColors.overlayColor,
              borderRadius: BorderRadius.circular(
                BaseTheme.borderRadiusSmall,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
