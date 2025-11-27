import 'package:flutter/material.dart';

import 'theme.dart';

class OverlayContent extends StatelessWidget {
  final VoidCallback onClose;
  final Widget child;

  const OverlayContent({super.key, required this.onClose, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: size.height * 0.33,
                left: size.width * 0.33,
                right: size.width * 0.33,
                bottom: size.height * 0.33,
              ),
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 16.0,
              ),
              decoration: BoxDecoration(
                color: BaseColors.overlayColor,
                borderRadius: BorderRadius.circular(
                  BaseTheme.borderRadiusSmall,
                ),
              ),
              child: child,
            ),
          ],
        ),
      ],
    );
  }
}
