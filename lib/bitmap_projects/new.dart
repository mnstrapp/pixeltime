import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'project.dart';
import 'provider.dart';

class NewBitmapProjectOverlay extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const NewBitmapProjectOverlay({super.key, required this.onClose});

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

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final navigator = Navigator.of(context);

    final name = _nameController.text;
    final description = _descriptionController.text;
    final (project, error) = await ref
        .read(bitmapProjectsProvider.notifier)
        .create(name: name, description: description);
    if (error != null) {
      _showError(error);
      return;
    }
    ref.read(bitmapProjectProvider.notifier).project = project;

    widget.onClose();
    navigator.push(
      MaterialPageRoute(builder: (context) => BitmapProjectScreen()),
    );
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
                onPressed: widget.onClose,
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
