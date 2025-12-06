import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/bitmap_projects_provider.dart';
import '../bitmap_projects/delete_overlay.dart';
import '../bitmap_projects/edit_overlay.dart';
import '../bitmap_projects/manage_projects_overlay.dart';
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

  void _buildMenuBarItems() {
    ref.read(workspaceMenuBarProvider.notifier).clear();
    ref
        .read(workspaceMenuBarProvider.notifier)
        .add(
          item: UIMenuBarItem(
            label: 'Projects',
            children: [
              UIMenuBarItem(label: 'New', icon: Icons.add, onPressed: () {}),
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
        );
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
      _buildMenuBarItems();
      ref.read(bitmapProjectsProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final menuBarItems = ref.watch(workspaceMenuBarProvider);
    final bitmapProjects = ref.watch(bitmapProjectsProvider);
    final recentProjects = bitmapProjects.take(5).toList();

    final tabs = ref.watch(workspaceTabsProvider);
    final workspaceIndex = ref.watch(workspaceIndexProvider);
    final projectScreen = ref
        .watch(workspaceProjectsProvider.notifier)
        .projectScreen;

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
            Positioned(
              top: 0,
              left: 0,
              child: UIMenuBar(children: menuBarItems),
            ),
            Positioned(
              bottom: 0,
              child: UITabBar(
                selectedIndex: workspaceIndex >= 0 ? workspaceIndex : null,
                onPressed: _onTabPressed,
                children: tabs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
