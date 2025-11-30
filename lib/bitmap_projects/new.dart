import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
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
  String? _errorMessage;

  final _nameFocusNode = FocusNode();
  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final project = BitmapProject(
        name: _nameController.text,
        description: _descriptionController.text,
      );
      final db = await getDatabase();
      final (_, createProjectError) = await project.create(db);
      if (createProjectError != null) {
        final errorMessage = createProjectError.contains('UNIQUE')
            ? 'Project name must be unique'
            : 'There was an error creating the project';
        setState(() {
          _errorMessage = errorMessage;
        });
        return;
      }
      widget.onSubmit(project);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating project: $e';
      });
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
                autofocus: true,
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
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
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
