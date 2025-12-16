import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pixeltime/bitmap_projects/tools/tools_provider.dart';

import '../../models/bitmap_project.dart';
import '../../ui/theme.dart';

import 'options.dart';
import 'select/options.dart';
import 'pencil/options.dart';
import 'eraser/options.dart';
import 'fill/options.dart';

class BitmapProjectToolsWidget extends ConsumerWidget {
  final BitmapProject project;
  const BitmapProjectToolsWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final backgroundColor = theme.menuBarTheme.style!.backgroundColor!.resolve({
      WidgetState.selected,
    });
    final foregroundColor = theme.menuButtonTheme.style!.foregroundColor!
        .resolve({
          WidgetState.selected,
        });

    final options = ref.watch(bitmapProjectToolOptionsProvider);

    double width = 275;
    double height = size.height * 0.8;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Column(
        spacing: BaseTheme.borderRadiusSmall,
        children: [
          Text('Tools', style: TextStyle(color: foregroundColor)),
          Expanded(child: _ToolList(project: project)),
          options ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _ToolList extends ConsumerStatefulWidget {
  final BitmapProject project;
  const _ToolList({required this.project});

  @override
  ConsumerState<_ToolList> createState() => _ToolListState();
}

class _ToolListState extends ConsumerState<_ToolList> {
  int selectedTool = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.inversePrimary;
    final tools = <_ToolItem>[
      _ToolItem(
        tooltip: 'Select',
        icon: Symbols.highlight_mouse_cursor,
        onTap: () {},
        options: BitmapProjectToolOptions.select,
      ),
      _ToolItem(
        tooltip: 'Draw',
        icon: Symbols.draw,
        onTap: () {},
        options: BitmapProjectToolOptions.pencil,
      ),
      _ToolItem(
        tooltip: 'Erase',
        icon: Symbols.ink_eraser,
        onTap: () {},
        options: BitmapProjectToolOptions.eraser,
      ),
      _ToolItem(
        tooltip: 'Fill',
        icon: Symbols.format_color_fill,
        onTap: () {},
        options: BitmapProjectToolOptions.fill,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: BaseTheme.borderRadiusSmall,
        crossAxisSpacing: BaseTheme.borderRadiusSmall,
        children: tools.map((tool) {
          final index = tools.indexOf(tool);
          return tool.copyWith(
            selected: selectedTool == index,
            onTap: () {
              setState(() {
                selectedTool = index;
              });
              tool.onTap();
            },
          );
        }).toList(),
      ),
    );
  }
}

class _ToolItem extends ConsumerWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;
  final BitmapProjectToolOptions options;

  const _ToolItem({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.selected = false,
    required this.options,
  });

  _ToolItem copyWith({
    VoidCallback? onTap,
    bool? selected,
    BitmapProjectToolOptions? options,
  }) => _ToolItem(
    tooltip: tooltip,
    icon: icon,
    onTap: onTap ?? this.onTap,
    selected: selected ?? this.selected,
    options: options ?? this.options,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          onTap();
          switch (options) {
            case BitmapProjectToolOptions.select:
              ref
                  .read(bitmapProjectToolOptionsProvider.notifier)
                  .set(BitmapProjectToolSelectOptions());
              break;
            case BitmapProjectToolOptions.pencil:
              ref
                  .read(bitmapProjectToolOptionsProvider.notifier)
                  .set(BitmapProjectToolPencilOptions());
              break;
            case BitmapProjectToolOptions.eraser:
              ref
                  .read(bitmapProjectToolOptionsProvider.notifier)
                  .set(BitmapProjectToolEraserOptions());
              break;
            case BitmapProjectToolOptions.fill:
              ref
                  .read(bitmapProjectToolOptionsProvider.notifier)
                  .set(BitmapProjectToolFillOptions());
              break;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
          ),
          child: Center(
            child: Icon(
              icon,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
