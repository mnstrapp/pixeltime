import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../workspace/workspace.dart';
import '../color_provider.dart';
import '../../../ui/theme.dart';
import '../options.dart';
import '../ui/color_picker_overlay.dart';

class BitmapProjectToolPencilOptions extends ConsumerWidget {
  const BitmapProjectToolPencilOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(bitmapProjectToolColorProvider);
    final workspace = Workspace.of(context);

    return BitmapProjectToolOptionsContainer(
      title: 'Pencil',
      child: Column(
        spacing: BaseTheme.borderRadiusSmall,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: BaseTheme.borderRadiusSmall,
            children: [
              const Text('Color'),
              InkWell(
                onTap: () {
                  workspace.showOverlay(
                    const BitmapProjectToolColorPickerOverlay(),
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(
                      BaseTheme.borderRadiusSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
