import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../models/bitmap_project.dart';
import '../../models/bitmap_project_layer.dart';
import 'layers_provider.dart';

class BitmapProjectLayersEditOverlay extends ConsumerStatefulWidget {
  final BitmapProject project;
  final BitmapProjectLayer layer;
  final VoidCallback onCancel;
  final Function(BitmapProjectLayer) onSubmit;

  const BitmapProjectLayersEditOverlay({
    super.key,
    required this.project,
    required this.layer,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  ConsumerState<BitmapProjectLayersEditOverlay> createState() =>
      _BitmapProjectLayersEditOverlayState();
}

class _BitmapProjectLayersEditOverlayState
    extends ConsumerState<BitmapProjectLayersEditOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  String? _errorMessage;

  Future<void> _editLayer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final layer = widget.layer.copyWith(name: _nameController.text);

    try {
      final (_, editError) = await ref
          .read(bitmapProjectLayersProvider.notifier)
          .update(layer: layer, originalLayer: widget.layer);
      if (editError != null) {
        setState(() {
          _errorMessage = editError;
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error editing layer: $e';
      });
      return;
    }

    widget.onSubmit(layer);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.layer.name;
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('Edit Layer', style: theme.textTheme.titleLarge),
        Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            focusNode: _nameFocusNode,
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            onEditingComplete: _editLayer,
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
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
                label: Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: _editLayer,
                icon: Icon(Symbols.add),
                label: Text('Update'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
