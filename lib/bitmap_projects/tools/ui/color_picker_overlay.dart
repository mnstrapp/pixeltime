import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../ui/theme.dart';
import '../../../ui/transparency_grid.dart';
import '../color_provider.dart';

class BitmapProjectToolColorPickerOverlay extends ConsumerStatefulWidget {
  final Function(Color)? onColorChanged;
  final Function(Color) onColorSelected;
  final VoidCallback onCancelled;

  const BitmapProjectToolColorPickerOverlay({
    super.key,
    this.onColorChanged,
    required this.onColorSelected,
    required this.onCancelled,
  });

  @override
  ConsumerState<BitmapProjectToolColorPickerOverlay> createState() =>
      _BitmapProjectToolColorPickerOverlayState();
}

class _BitmapProjectToolColorPickerOverlayState
    extends ConsumerState<BitmapProjectToolColorPickerOverlay> {
  double _redValue = 0.0;
  double _greenValue = 0.0;
  double _blueValue = 0.0;
  double _alphaValue = 1.0;
  late Color _color;
  final _hexController = TextEditingController();

  void _setRedValue(double value) {
    setState(() {
      _redValue = value;
      _refreshColor();
      widget.onColorChanged?.call(_color);
    });
  }

  void _setGreenValue(double value) {
    setState(() {
      _greenValue = value;
      _refreshColor();
      widget.onColorChanged?.call(_color);
    });
  }

  void _setBlueValue(double value) {
    setState(() {
      _blueValue = value;
      _refreshColor();
      widget.onColorChanged?.call(_color);
    });
  }

  void _setAlphaValue(double value) {
    setState(() {
      _alphaValue = value;
      _refreshColor();
      widget.onColorChanged?.call(_color);
    });
  }

  void _setHexValue(String value) {
    final hexValue = value.replaceAll('#', '');
    final color = Color(int.parse('0xFF$hexValue'));
    setState(() {
      _redValue = (color.r * 255.0).clamp(0.0, 255.0);
      _greenValue = (color.g * 255.0).clamp(0.0, 255.0);
      _blueValue = (color.b * 255.0).clamp(0.0, 255.0);
      _refreshColor();
      widget.onColorChanged?.call(_color);
    });
  }

  void _refreshColor() {
    setState(() {
      if (_alphaValue == 0.0) {
        _color = Colors.transparent;
      } else {
        _color = Color.fromRGBO(
          _redValue.toInt(),
          _greenValue.toInt(),
          _blueValue.toInt(),
          _alphaValue,
        );
      }
    });
  }

  void _onPreviousColorSelected(Color color) {
    ref.read(bitmapProjectToolPreviousColorsProvider.notifier).add(color);
    setState(() {
      _redValue = (color.r * 255.0).clamp(0.0, 255.0);
      _greenValue = (color.g * 255.0).clamp(0.0, 255.0);
      _blueValue = (color.b * 255.0).clamp(0.0, 255.0);
      _alphaValue = color.a;
      _refreshColor();
    });
    widget.onColorChanged?.call(color);
  }

  void _onColorSelected(Color color) {
    ref.read(bitmapProjectToolPreviousColorsProvider.notifier).add(color);
    widget.onColorSelected(color);
  }

  @override
  void initState() {
    super.initState();
    final currentColor = ref.read(bitmapProjectToolColorProvider);
    _redValue = (currentColor.r * 255.0).clamp(0.0, 255.0);
    _greenValue = (currentColor.g * 255.0).clamp(0.0, 255.0);
    _blueValue = (currentColor.b * 255.0).clamp(0.0, 255.0);
    _alphaValue = currentColor.a;
    _refreshColor();
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = ref.watch(bitmapProjectToolColorProvider);
    final previousColorsState = ref
        .watch(bitmapProjectToolPreviousColorsProvider)
        .reversed
        .take(20)
        .toList();
    List<Color> previousColors = [];
    for (var i = 0; i < 20; i++) {
      if (i < previousColorsState.length) {
        previousColors.add(previousColorsState[i]);
      } else {
        previousColors.add(Colors.transparent);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Color Picker'),
          Container(
            margin: EdgeInsets.all(BaseTheme.borderRadiusSmall),
            child: Row(
              spacing: BaseTheme.borderRadiusSmall,
              children: [
                Column(
                  spacing: BaseTheme.borderRadiusSmall,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 115,
                      child: _ColorPickerColorItem(color: _color),
                    ),
                    SizedBox(
                      width: 200,
                      height: 115,
                      child: _ColorPickerColorItem(color: currentColor),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('R'),
                          Expanded(
                            child: Slider(
                              value: _redValue,
                              onChanged: _setRedValue,
                              min: 0.0,
                              max: 255.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('G'),
                          Expanded(
                            child: Slider(
                              value: _greenValue,
                              onChanged: _setGreenValue,
                              min: 0.0,
                              max: 255.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('B'),
                          Expanded(
                            child: Slider(
                              value: _blueValue,
                              onChanged: _setBlueValue,
                              min: 0.0,
                              max: 255.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('A'),
                          Expanded(
                            child: Slider(
                              value: _alphaValue,
                              onChanged: _setAlphaValue,
                              min: 0.0,
                              max: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Hex'),
                          Expanded(
                            child: TextField(
                              controller: _hexController,
                              onChanged: _setHexValue,
                              onEditingComplete: () => _onColorSelected(_color),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: BaseTheme.borderRadiusSmall,
              crossAxisSpacing: BaseTheme.borderRadiusSmall,
            ),
            itemCount: previousColors.length,
            itemBuilder: (context, index) {
              final color = previousColors[index];
              return InkWell(
                onTap: () => _onPreviousColorSelected(color),
                child: _ColorPickerGridItem(color: color),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: BaseTheme.borderRadiusSmall,
              top: BaseTheme.borderRadiusSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: widget.onCancelled,
                  icon: Icon(Icons.cancel),
                  label: Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () => _onColorSelected(_color),
                  icon: Icon(Symbols.check),
                  label: Text('Apply'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorPickerColorItem extends StatelessWidget {
  final Color color;

  const _ColorPickerColorItem({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth - 4.0,
          constraints.maxHeight - 4.0,
        );
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              BaseTheme.borderRadiusSmall,
            ),
            color: color != Colors.transparent ? color : null,
          ),
          child: color == Colors.transparent
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    BaseTheme.borderRadiusSmall,
                  ),
                  child: TransparencyGrid(
                    size: size,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _ColorPickerGridItem extends StatelessWidget {
  final Color color;

  const _ColorPickerGridItem({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth - 4.0,
          constraints.maxHeight - 4.0,
        );
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: color != Colors.transparent ? color : null,
            borderRadius: BorderRadius.circular(
              BaseTheme.borderRadiusSmall,
            ),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: color == Colors.transparent
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    BaseTheme.borderRadiusSmall,
                  ),
                  child: TransparencyGrid(size: size),
                )
              : null,
        );
      },
    );
  }
}
