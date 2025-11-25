import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/menu_bar.dart';
import '../ui/scaffolf.dart';
import 'provider.dart';

class BitmapProjectScreen extends ConsumerWidget {
  const BitmapProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(bitmapProjectProvider);
    if (project == null) {
      return const Scaffold(
        body: Column(
          children: [
            UIMenuBar(),
            Center(child: Text('Project not found')),
          ],
        ),
      );
    }
    return UIScaffold(
      menuBarItems: [
        UIMenuBarItem(
          label: 'File',
          children: [
            UIMenuBarItem(label: 'Save', icon: Icons.save),
            UIMenuBarItem(label: 'Save As', icon: Icons.save_as),
          ],
        ),
        UIMenuBarItem(
          label: 'Edit',
          children: [
            UIMenuBarItem(label: 'Undo', icon: Icons.undo),
            UIMenuBarItem(label: 'Redo', icon: Icons.redo),
            UIMenuBarItem(label: 'Cut', icon: Icons.cut),
            UIMenuBarItem(label: 'Copy', icon: Icons.copy),
            UIMenuBarItem(label: 'Paste', icon: Icons.paste),
          ],
        ),
        UIMenuBarItem(
          label: 'View',
          children: [
            UIMenuBarItem(label: 'Zoom In', icon: Icons.zoom_in),
            UIMenuBarItem(label: 'Zoom Out', icon: Icons.zoom_out),
            UIMenuBarItem(label: 'Actual Size', icon: Icons.fit_screen),
          ],
        ),
      ],
      child: Center(child: Text(project.name)),
    );
  }
}
