import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/bitmap_project.dart';

class NewBitmapProjectOverlay extends ConsumerStatefulWidget {
  final VoidCallback onCancel;
  final Function(BitmapProject) onSubmit;

  const NewBitmapProjectOverlay({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  ConsumerState<NewBitmapProjectOverlay> createState() =>
      _NewBitmapProjectOverlayState();
}

class _NewBitmapProjectOverlayState
    extends ConsumerState<NewBitmapProjectOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _nameFocusNode = FocusNode();
  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final uuid = const Uuid().v4();
      final createdAt = DateTime.now().toIso8601String();
      final updatedAt = DateTime.now().toIso8601String();

      final project = BitmapProject(
        id: uuid,
        name: _nameController.text,
        description: _descriptionController.text,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      widget.onSubmit(project);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating project: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'New Project',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                focusNode: _nameFocusNode,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                onEditingComplete: _createProject,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onEditingComplete: _createProject,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: _createProject,
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
