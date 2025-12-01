import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';

class DeleteBitmapProjectOverlay extends ConsumerWidget {
  final BitmapProject project;
  final VoidCallback onCancel;
  final Function(BitmapProject) onDelete;

  const DeleteBitmapProjectOverlay({
    super.key,
    required this.project,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'Delete Project',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Are you sure you want to delete this project?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () => onDelete(project),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
