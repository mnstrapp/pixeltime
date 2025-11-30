import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/new.dart';
import '../models/bitmap_project.dart';
import '../ui/overlay_content.dart';
import '../ui/menu_bar.dart';
import '../ui/tab_bar.dart';
import 'index_provider.dart';
import 'menu_bar_provider.dart';
import 'projects_provider.dart';
import 'tabs_provider.dart';
import 'workspace_provider.dart';

class Workspace extends ConsumerStatefulWidget {
  const Workspace({super.key});

  @override
  ConsumerState<Workspace> createState() => WorkspaceState();

  static WorkspaceState of(BuildContext context) {
    WorkspaceState? state = context.findAncestorStateOfType<WorkspaceState>();
    if (state == null) {
      throw Exception('Workspace not found in context');
    }
    return state;
  }
}

class WorkspaceState extends ConsumerState<Workspace> {
  final _overlayController = OverlayPortalController();
  Widget? _overlayContent;

  void showOverlay(Widget overlayContent) {
    setState(() {
      _overlayContent = OverlayContent(
        onClose: hideOverlay,
        child: overlayContent,
      );
    });
    _overlayController.show();
  }

  void hideOverlay() {
    setState(() {
      _overlayContent = null;
    });
    _overlayController.hide();
  }

  List<UIMenuBarItem> _buildMenuBarItems() {
    return [
      UIMenuBarItem(
        label: 'Projects',
        children: [
          UIMenuBarItem(
            label: 'New',
            icon: Icons.add,
            onPressed: () {
              showOverlay(
                NewBitmapProjectOverlay(
                  onCancel: hideOverlay,
                  onSubmit: (project) {
                    final (success, error) = ref
                        .read(workspaceProvider.notifier)
                        .add(project);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                      return;
                    }
                    hideOverlay();
                  },
                ),
              );
            },
          ),
          UIMenuBarItem(label: 'Open', icon: Icons.open_in_new),
        ],
      ),
      ...ref.watch(workspaceMenuBarProvider),
      UIMenuBarItem(
        label: 'Help',
        children: [
          UIMenuBarItem(label: 'About', icon: Icons.info),
        ],
      ),
    ];
  }

  void _onTabClosed(int index) {
    final messenger = ScaffoldMessenger.of(context);
    final (success, error) = ref.read(workspaceProvider.notifier).remove(index);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void _onTabPressed(int index) {
    ref.read(workspaceIndexProvider.notifier).index(index);
  }

  Future<void> _onSave() async {
    final messenger = ScaffoldMessenger.of(context);
    final (success, error) = await ref.read(workspaceProvider.notifier).save();
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _onSaveAll() async {
    final messenger = ScaffoldMessenger.of(context);
    final (success, error) = await ref
        .read(workspaceProvider.notifier)
        .saveAll();
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _onSubmitNewProject(BitmapProject project) async {
    final messenger = ScaffoldMessenger.of(context);
    final (_, addProjectError) = ref
        .read(workspaceProvider.notifier)
        .add(project);
    if (addProjectError != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(addProjectError)),
      );
      return;
    }
    final (_, saveProjectError) = await ref
        .read(workspaceProvider.notifier)
        .save();
    if (saveProjectError != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(saveProjectError)),
      );
      return;
    }
    hideOverlay();
    messenger.showSnackBar(
      SnackBar(content: Text('Project created and saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<UIMenuBarItem> menuBarItems = _buildMenuBarItems();
    final tabs = ref.watch(workspaceTabsProvider);
    final workspaceIndex = ref.watch(workspaceIndexProvider);
    final projectScreen = ref
        .watch(workspaceProjectsProvider.notifier)
        .projectScreen;

    if (projectScreen != null) {
      menuBarItems = [
        ...menuBarItems.sublist(0, 1),
        UIMenuBarItem(
          label: 'File',
          icon: Icons.save,
          children: [
            UIMenuBarItem(
              label: 'Save',
              icon: Icons.save,
              onPressed: _onSave,
            ),
            UIMenuBarItem(
              label: 'Save All',
              icon: Icons.save,
              onPressed: _onSaveAll,
            ),
            UIMenuBarItem(
              label: 'Close',
              icon: Icons.close,
              onPressed: () => _onTabClosed(workspaceIndex),
            ),
          ],
        ),
        ...menuBarItems.sublist(1),
      ];
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            OverlayPortal(
              controller: _overlayController,
              overlayChildBuilder: (context) => _overlayContent!,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                UIMenuBar(children: menuBarItems),
                Expanded(
                  child:
                      projectScreen ??
                      Center(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('New Project'),
                          onPressed: () {
                            showOverlay(
                              NewBitmapProjectOverlay(
                                onCancel: hideOverlay,
                                onSubmit: _onSubmitNewProject,
                              ),
                            );
                          },
                        ),
                      ),
                ),
                Center(
                  child: UITabBar(
                    selectedIndex: workspaceIndex >= 0 ? workspaceIndex : null,
                    onPressed: _onTabPressed,
                    onClosed: _onTabClosed,
                    children: tabs,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
