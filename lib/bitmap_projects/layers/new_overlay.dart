import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../models/bitmap_project.dart';
import '../../models/bitmap_project_layer.dart';
import 'layers_provider.dart';

class BitmapProjectLayersNewOverlay extends ConsumerStatefulWidget {
  final BitmapProject project;
  final VoidCallback onCancel;
  final Function(BitmapProjectLayer) onSubmit;

  const BitmapProjectLayersNewOverlay({
    super.key,
    required this.project,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  ConsumerState<BitmapProjectLayersNewOverlay> createState() =>
      _BitmapProjectLayersNewOverlayState();
}

class _BitmapProjectLayersNewOverlayState
    extends ConsumerState<BitmapProjectLayersNewOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  String? _errorMessage;

  Future<void> _createLayer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final layers = ref.read(bitmapProjectLayersProvider);
    final layer = BitmapProjectLayer(
      name: _nameController.text,
      projectId: widget.project.id!,
      position: layers.isNotEmpty ? layers.last.position + 1 : 0,
    );

    try {
      final (_, createError) = await ref
          .read(bitmapProjectLayersProvider.notifier)
          .create(layer: layer);
      if (createError != null) {
        setState(() {
          _errorMessage = createError;
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating layer: $e';
      });
      return;
    }

    widget.onSubmit(layer);
  }

  @override
  void initState() {
    super.initState();
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('New Layer', style: theme.textTheme.titleLarge),
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
            onEditingComplete: _createLayer,
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
                onPressed: _createLayer,
                icon: Icon(Symbols.add),
                label: Text('Create'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
