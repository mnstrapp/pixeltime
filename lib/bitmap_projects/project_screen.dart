import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';
import '../ui/menu_bar.dart';
import '../ui/theme.dart';
import '../workspace/index_provider.dart';
import '../workspace/menu_bar_provider.dart';
import '../workspace/workspace_provider.dart';
import 'history.dart';
import 'layers/layers_widget.dart';

class BitmapProjectScreen extends ConsumerStatefulWidget {
  final BitmapProject project;
  const BitmapProjectScreen({super.key, required this.project});

  @override
  ConsumerState<BitmapProjectScreen> createState() =>
      BitmapProjectScreenState();

  static BitmapProjectScreenState of(BuildContext context) {
    final state = context.findAncestorStateOfType<BitmapProjectScreenState>();
    if (state == null) {
      throw Exception('BitmapProjectScreen not found in context');
    }
    return state;
  }
}

class BitmapProjectScreenState extends ConsumerState<BitmapProjectScreen> {
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();

  UIMenuBarItem? _fileMenuBarItem;

  void _onSave() {
    ref.read(workspaceProvider.notifier).save();
  }

  void _close() async {
    final messenger = ScaffoldMessenger.of(context);
    final (_, error) = await ref
        .read(workspaceProvider.notifier)
        .remove(ref.read(workspaceIndexProvider));
    _cleanMenuBar();
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void _buildMenuBar() {
    ref
        .read(workspaceMenuBarProvider.notifier)
        .add(
          item: UIMenuBarItem(
            label: 'File',
            icon: Icons.save,
            children: [
              UIMenuBarItem(
                label: 'Save',
                icon: Icons.save,
                onPressed: _onSave,
              ),
              UIMenuBarItem(
                label: 'Close',
                icon: Icons.close,
                onPressed: _close,
              ),
            ],
          ),
        );
  }

  void _cleanMenuBar() {
    if (_fileMenuBarItem != null) {
      ref
          .read(workspaceMenuBarProvider.notifier)
          .remove(label: _fileMenuBarItem!.label);
      _fileMenuBarItem = null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fileMenuBarItem = UIMenuBarItem(
        label: 'File',
        icon: Icons.save,
        children: [
          UIMenuBarItem(label: 'Save', icon: Icons.save, onPressed: _onSave),
          UIMenuBarItem(label: 'Close', icon: Icons.close, onPressed: _close),
        ],
      );
      _buildMenuBar();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: Center(child: Text(project.name)),
            ),
          ),
        ),
        Positioned(
          right: BaseTheme.borderRadiusMedium,
          top: 0,
          bottom: 0,
          child: Center(child: BitmapProjectLayersWidget(project: project)),
        ),
      ],
    );
  }
}
