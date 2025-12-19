import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../ui/theme.dart';
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
    final size = MediaQuery.sizeOf(context);
    final maxSize = size.width < size.height
        ? size.width * 0.33
        : size.height * 0.33;

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
      // height: size.height - maxSize * 2,
      // width: size.width - maxSize * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: Column(
        children: [
          Text('Color Picker'),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(BaseTheme.borderRadiusSmall),
              child: Row(
                spacing: BaseTheme.borderRadiusSmall,
                children: [
                  Expanded(
                    child: Column(
                      spacing: BaseTheme.borderRadiusSmall,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                BaseTheme.borderRadiusSmall,
                              ),
                              color: _color != Colors.transparent
                                  ? _color
                                  : null,
                              image: _color == Colors.transparent
                                  ? DecorationImage(
                                      image: AssetImage(
                                        'assets/transparency.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                BaseTheme.borderRadiusSmall,
                              ),
                              color: currentColor != Colors.transparent
                                  ? currentColor
                                  : null,
                              image: currentColor == Colors.transparent
                                  ? DecorationImage(
                                      image: AssetImage(
                                        'assets/transparency.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                onEditingComplete: () =>
                                    _onColorSelected(_color),
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
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(
                      BaseTheme.borderRadiusSmall,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    image: color == Colors.transparent
                        ? DecorationImage(
                            image: AssetImage('assets/transparency.png'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
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
