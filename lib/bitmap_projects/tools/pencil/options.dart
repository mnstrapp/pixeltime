import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ui/transparency_grid.dart';
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
                    BitmapProjectToolColorPickerOverlay(
                      onColorSelected: (color) {
                        ref
                            .read(bitmapProjectToolColorProvider.notifier)
                            .set(color);
                        workspace.hideOverlay();
                      },
                      onCancelled: () {
                        workspace.hideOverlay();
                      },
                    ),
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color != Colors.transparent ? color : null,
                    borderRadius: BorderRadius.circular(
                      BaseTheme.borderRadiusSmall,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: color == Colors.transparent
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            BaseTheme.borderRadiusSmall,
                          ),
                          child: TransparencyGrid(size: Size(44, 44)),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
