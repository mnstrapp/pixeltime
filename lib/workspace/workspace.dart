import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bitmap_projects/new.dart';
import '../ui/overlay_content.dart';
import '../ui/menu_bar.dart';
import '../ui/tab_bar.dart';
import 'index_provider.dart';
import 'menu_bar_provider.dart';
import 'pages_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final menuBarItems = _buildMenuBarItems();
    final tabs = ref.watch(workspaceTabsProvider);
    final workspaceIndex = ref.watch(workspaceIndexProvider);
    final page = ref.watch(workspacePagesProvider.notifier).page;

    return Scaffold(
      body: Stack(
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
                    page ??
                    Center(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('New Project'),
                        onPressed: () {
                          showOverlay(
                            NewBitmapProjectOverlay(
                              onCancel: hideOverlay,
                              onSubmit: (project) {
                                ref
                                    .read(workspaceProvider.notifier)
                                    .add(project);
                                hideOverlay();
                              },
                            ),
                          );
                        },
                      ),
                    ),
              ),
              Center(
                child: UITabBar(
                  selectedIndex: workspaceIndex >= 0 ? workspaceIndex : null,
                  onTabPressed: (index) {
                    ref.read(workspaceIndexProvider.notifier).index(index);
                  },
                  children: tabs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
