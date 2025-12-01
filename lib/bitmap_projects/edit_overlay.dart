import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';

class EditBitmapProjectOverlay extends ConsumerStatefulWidget {
  final BitmapProject project;
  final VoidCallback onCancel;
  final Function(BitmapProject) onSubmit;

  const EditBitmapProjectOverlay({
    super.key,
    required this.project,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  ConsumerState<EditBitmapProjectOverlay> createState() =>
      _EditBitmapProjectOverlayState();
}

class _EditBitmapProjectOverlayState
    extends ConsumerState<EditBitmapProjectOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _errorMessage;

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  Future<void> _editProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final project = widget.project.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
      );
      final (_, editProjectError) = await project.update();
      if (editProjectError != null) {
        if (editProjectError.contains('UNIQUE')) {
          setState(() {
            _errorMessage = 'Project name must be unique';
          });
          return;
        }
        setState(() {
          _errorMessage = editProjectError;
        });
      }
      widget.onSubmit(project);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error editing project: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.project.name;
    _descriptionController.text = widget.project.description;
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Edit Project',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                onEditingComplete: _editProject,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onEditingComplete: _editProject,
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
                onPressed: _editProject,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
