import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../models/bitmap_project.dart';
import '../../models/bitmap_project_layer.dart';
import '../../ui/theme.dart';
import '../../workspace/workspace.dart';
import 'edit_overlay.dart';
import 'layers_provider.dart';
import 'new_overlay.dart';

class BitmapProjectLayersWidget extends ConsumerWidget {
  final BitmapProject project;
  const BitmapProjectLayersWidget({super.key, required this.project});

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
          Expanded(child: _LayerList(project: project)),
          _LayerActions(project: project),
        ],
      ),
    );
  }
}

class _LayerList extends ConsumerStatefulWidget {
  final BitmapProject project;
  const _LayerList({required this.project});

  @override
  ConsumerState<_LayerList> createState() => _LayerListState();
}

class _LayerListState extends ConsumerState<_LayerList> {
  Future<void> _loadAll() async {
    final (_, loadAllError) = await ref
        .read(bitmapProjectLayersProvider.notifier)
        .loadAll(project: widget.project);
    if (loadAllError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loadAllError)));
      return;
    }
  }

  Future<void> _onToggleVisibility(BitmapProjectLayer layer) async {
    final (_, toggleVisibilityError) = await ref
        .read(bitmapProjectLayersProvider.notifier)
        .toggleVisibility(layer: layer);
    if (toggleVisibilityError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(toggleVisibilityError)));
      return;
    }
    _loadAll();
  }

  void _onDrag(BitmapProjectLayer layer) {
    // ref
    //     .read(bitmapProjectLayersProvider.notifier)
    //     .drag(layer: layer, newPosition: newPosition);
  }

  void _onEdit(BitmapProjectLayer layer) {
    final workspaceState = Workspace.of(context);
    workspaceState.showOverlay(
      BitmapProjectLayersEditOverlay(
        project: widget.project,
        layer: layer,
        onCancel: workspaceState.hideOverlay,
        onSubmit: _onEditSubmit,
      ),
    );
  }

  Future<void> _onEditSubmit(BitmapProjectLayer layer) async {
    final workspaceState = Workspace.of(context);
    await _loadAll();
    workspaceState.hideOverlay();
  }

  void _onDelete(BitmapProjectLayer layer) {
    ref.read(bitmapProjectLayersProvider.notifier).delete(layer: layer);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final (_, error) = await ref
          .read(bitmapProjectLayersProvider.notifier)
          .loadAll(project: widget.project);
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final layers = ref.watch(bitmapProjectLayersProvider);
    final color = Theme.of(context).colorScheme.inversePrimary;
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...layers.map(
              (layer) => _LayerItem(
                layer: layer,
                onToggleVisibility: () => _onToggleVisibility(layer),
                onDrag: () => _onDrag(layer),
                onEdit: () => _onEdit(layer),
                onDelete: () => _onDelete(layer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayerItem extends StatelessWidget {
  final BitmapProjectLayer layer;
  final VoidCallback onToggleVisibility;
  final VoidCallback onDrag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LayerItem({
    required this.layer,
    required this.onToggleVisibility,
    required this.onDrag,
    required this.onEdit,
    required this.onDelete,
  });

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
            child: InkWell(
              onTap: onToggleVisibility,
              child: Icon(
                layer.visible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          Tooltip(
            message: 'Drag',
            child: InkWell(onTap: onDrag, child: Icon(Icons.drag_handle)),
          ),
          Expanded(child: Text(layer.name)),
          Tooltip(
            message: 'Edit',
            child: InkWell(onTap: onEdit, child: Icon(Icons.edit)),
          ),
          Tooltip(
            message: 'Delete',
            child: InkWell(onTap: onDelete, child: Icon(Icons.delete)),
          ),
        ],
      ),
    );
  }
}

class _LayerActions extends ConsumerStatefulWidget {
  final BitmapProject project;
  const _LayerActions({required this.project});

  @override
  ConsumerState<_LayerActions> createState() => _LayerActionsState();
}

class _LayerActionsState extends ConsumerState<_LayerActions> {
  void _addLayerDialog() {
    final workspaceState = Workspace.of(context);
    workspaceState.showOverlay(
      BitmapProjectLayersNewOverlay(
        project: widget.project,
        onCancel: workspaceState.hideOverlay,
        onSubmit: _addLayer,
      ),
    );
  }

  void _addLayer(BitmapProjectLayer layer) {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final workspaceState = Workspace.of(context);
      workspaceState.hideOverlay();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(bitmapProjectLayersProvider.notifier)
          .loadAll(project: widget.project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LayerAction(
          tooltip: 'Add a layer',
          icon: Symbols.note_add,
          onTap: _addLayerDialog,
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
