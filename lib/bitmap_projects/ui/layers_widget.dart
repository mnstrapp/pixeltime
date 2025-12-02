import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../ui/theme.dart';

class BitmapProjectLayersWidget extends ConsumerWidget {
  const BitmapProjectLayersWidget({super.key});

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

    return Container(
      width: size.width * 0.2,
      height: size.height * 0.8,
      padding: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Column(
        spacing: BaseTheme.borderRadiusSmall,
        children: [
          Text('Layers', style: TextStyle(color: foregroundColor)),
          Expanded(child: _LayerList()),
          _LayerActions(),
        ],
      ),
    );
  }
}

class _LayerList extends StatelessWidget {
  const _LayerList();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.inversePrimary;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Column(
        children: [
          _LayerItem(name: 'Layer 1'),
          _LayerItem(name: 'Layer 2'),
        ],
      ),
    );
  }
}

class _LayerItem extends StatelessWidget {
  final String name;

  const _LayerItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      child: Row(
        spacing: BaseTheme.borderRadiusSmall,
        children: [
          Tooltip(
            message: 'Visibility',
            child: InkWell(onTap: () {}, child: Icon(Icons.visibility)),
          ),
          Tooltip(
            message: 'Drag',
            child: InkWell(onTap: () {}, child: Icon(Icons.drag_handle)),
          ),
          Expanded(child: Text(name)),
          Tooltip(
            message: 'Edit',
            child: InkWell(onTap: () {}, child: Icon(Icons.edit)),
          ),
          Tooltip(
            message: 'Delete',
            child: InkWell(onTap: () {}, child: Icon(Icons.delete)),
          ),
        ],
      ),
    );
  }
}

class _LayerActions extends StatelessWidget {
  const _LayerActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LayerAction(
          tooltip: 'Add a layer',
          icon: Symbols.note_add,
          onTap: () {},
        ),
        _LayerAction(
          tooltip: 'Add a group',
          icon: Symbols.note_stack_add,
          onTap: () {},
        ),
      ],
    );
  }
}

class _LayerAction extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;

  const _LayerAction({required this.tooltip, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.menuButtonTheme.style!.foregroundColor!.resolve({
      WidgetState.selected,
    });
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: color),
      ),
    );
  }
}
