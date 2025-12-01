import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/bitmap_projects_provider.dart';
import '../bitmap_projects/delete_overlay.dart';
import '../bitmap_projects/edit_overlay.dart';
import '../bitmap_projects/manage_projcets_overlay.dart';
import '../bitmap_projects/new_overlay.dart';
import '../bitmap_projects/open_overlay.dart';
import '../models/bitmap_project.dart';
import '../ui/overlay_content.dart';
import '../ui/menu_bar.dart';
import '../ui/tab_bar.dart';
import '../ui/theme.dart';
import 'index_provider.dart';
import '../bitmap_projects/project_tile.dart';
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
                  onSubmit: _onSubmitNewProject,
                ),
              );
            },
          ),
          UIMenuBarItem(
            label: 'Open',
            icon: Icons.open_in_new,
            onPressed: () {
              showOverlay(
                OpenBitmapProjectOverlay(
                  onCancel: hideOverlay,
                  onOpen: _onOpenProject,
                ),
              );
            },
          ),
          UIMenuBarItem(
            label: 'Manage',
            icon: Icons.manage_accounts,
            onPressed: _onManageProjects,
          ),
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

  void _onManageProjects() {
    showOverlay(
      ManageProjectsOverlay(
        onCancel: hideOverlay,
        onTapProject: _onOpenProject,
        onEditProject: _onEditProject,
        onDeleteProject: _onDeleteProject,
      ),
    );
  }

  Future<void> _onDeleteProjectSubmit(BitmapProject project) async {
    final messenger = ScaffoldMessenger.of(context);
    final (_, deleteProjectError) = await ref
        .read(workspaceProvider.notifier)
        .delete(project);
    if (deleteProjectError != null) {
      messenger.showSnackBar(SnackBar(content: Text(deleteProjectError)));
    }
    hideOverlay();
  }

  Future<void> _onDeleteProject(BitmapProject project) async {
    hideOverlay();
    showOverlay(
      DeleteBitmapProjectOverlay(
        project: project,
        onCancel: hideOverlay,
        onDelete: _onDeleteProjectSubmit,
      ),
    );
  }

  Future<void> _onEditProjectSubmit(BitmapProject project) async {
    final messenger = ScaffoldMessenger.of(context);
    final (_, updateProjectError) = await ref
        .read(workspaceProvider.notifier)
        .update(project);
    if (updateProjectError != null) {
      messenger.showSnackBar(SnackBar(content: Text(updateProjectError)));
    }
    hideOverlay();
  }

  void _onEditProject(BitmapProject project) {
    hideOverlay();
    showOverlay(
      EditBitmapProjectOverlay(
        project: project,
        onCancel: hideOverlay,
        onSubmit: _onEditProjectSubmit,
      ),
    );
  }

  void _onOpenProject(BitmapProject project) {
    final messenger = ScaffoldMessenger.of(context);
    final (_, addProjectError) = ref
        .read(workspaceProvider.notifier)
        .add(project);
    if (addProjectError != null) {
      messenger.showSnackBar(SnackBar(content: Text(addProjectError)));
    }
    hideOverlay();
  }

  Future<void> _onTabClosed(int index) async {
    final messenger = ScaffoldMessenger.of(context);
    final (success, error) = await ref
        .read(workspaceProvider.notifier)
        .remove(index);
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

  void _onSubmitNewProject(BitmapProject project) {
    final messenger = ScaffoldMessenger.of(context);
    final (_, addProjectError) = ref
        .read(workspaceProvider.notifier)
        .add(project);
    if (addProjectError != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(addProjectError)),
      );
    }
    hideOverlay();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(bitmapProjectsProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    List<UIMenuBarItem> menuBarItems = _buildMenuBarItems();
    final bitmapProjects = ref.watch(bitmapProjectsProvider);
    final recentProjects = bitmapProjects.take(5).toList();

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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
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
                          if (recentProjects.isNotEmpty)
                            Container(
                              width: size.width > BreakPoints.mobileBreakpoint
                                  ? size.width * 0.33
                                  : size.width,
                              margin: EdgeInsets.all(
                                BaseTheme.borderRadiusMedium,
                              ),
                              padding: EdgeInsets.all(
                                BaseTheme.borderRadiusSmall,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(
                                  BaseTheme.borderRadiusSmall,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text('Recent Projects'),
                                  ...recentProjects.map(
                                    (project) => BitmapProjectTile(
                                      project: project,
                                      onTap: () {
                                        ref
                                            .read(workspaceProvider.notifier)
                                            .add(project);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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
