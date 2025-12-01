import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';
import '../ui/theme.dart';
import 'bitmap_projects_provider.dart';
import 'project_tile.dart';

class OpenBitmapProjectOverlay extends ConsumerStatefulWidget {
  final VoidCallback onCancel;
  final Function(BitmapProject) onOpen;

  const OpenBitmapProjectOverlay({
    super.key,
    required this.onCancel,
    required this.onOpen,
  });

  @override
  ConsumerState<OpenBitmapProjectOverlay> createState() =>
      _OpenBitmapProjectOverlayState();
}

class _OpenBitmapProjectOverlayState
    extends ConsumerState<OpenBitmapProjectOverlay> {
  final _filterController = TextEditingController();
  final _filterFocusNode = FocusNode();
  List<BitmapProject> _filteredProjects = [];

  void _filterProjects() {
    final filterText = _filterController.text;
    final projects = ref
        .read(bitmapProjectsProvider)
        .where(
          (project) =>
              project.name.contains(filterText) ||
              project.description.contains(filterText),
        )
        .toSet()
        .toList();

    projects.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    setState(() {
      _filteredProjects = projects;
    });
  }

  @override
  void initState() {
    super.initState();
    _filterFocusNode.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final (projects, error) = await ref
          .read(bitmapProjectsProvider.notifier)
          .loadAll();
      if (error != null) {
        return;
      }
      setState(() {
        _filteredProjects = projects;
      });
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    _filterFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Open Project',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextFormField(
          controller: _filterController,
          focusNode: _filterFocusNode,
          decoration: InputDecoration(
            labelText: 'Filter',
          ),
          onChanged: (value) => _filterProjects(),
          onEditingComplete: _filterProjects,
        ),
        SingleChildScrollView(
          padding: EdgeInsets.only(
            top: BaseTheme.borderRadiusSmall,
            bottom: BaseTheme.borderRadiusSmall,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._filteredProjects.map(
                (project) => BitmapProjectTile(
                  project: project,
                  onTap: () => widget.onOpen(project),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
