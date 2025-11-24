import 'package:flutter/material.dart';

class NewBitmapProjectOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const NewBitmapProjectOverlay({super.key, required this.onClose});

  @override
  State<NewBitmapProjectOverlay> createState() =>
      _NewBitmapProjectOverlayState();
}

class _NewBitmapProjectOverlayState extends State<NewBitmapProjectOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _nameFocusNode = FocusNode();

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
          child: TextFormField(
            focusNode: _nameFocusNode,
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
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
                onPressed: () => Navigator.pop(context),
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
