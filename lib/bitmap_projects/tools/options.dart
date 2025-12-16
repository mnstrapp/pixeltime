import 'package:flutter/material.dart';
import 'package:pixeltime/ui/theme.dart';

enum BitmapProjectToolOptions {
  select,
  pencil,
  eraser,
  fill,
}

class BitmapProjectToolOptionsContainer extends StatelessWidget {
  final String title;
  final Widget? child;
  const BitmapProjectToolOptionsContainer({
    super.key,
    this.title = '',
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.surface;

    if (child == null && title.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Column(
        spacing: BaseTheme.borderRadiusSmall,
        children: [
          title.isNotEmpty ? Text(title) : const SizedBox.shrink(),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
