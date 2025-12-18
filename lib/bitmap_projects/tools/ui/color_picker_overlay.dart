import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ui/theme.dart';
import '../color_provider.dart';

class BitmapProjectToolColorPickerOverlay extends ConsumerStatefulWidget {
  const BitmapProjectToolColorPickerOverlay({super.key});

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
  Color? _color;
  final _hexController = TextEditingController();

  void _setRedValue(double value) {
    setState(() {
      _redValue = value;
    });
    _refreshColor();
  }

  void _setGreenValue(double value) {
    setState(() {
      _greenValue = value;
    });
    _refreshColor();
  }

  void _setBlueValue(double value) {
    setState(() {
      _blueValue = value;
    });
    _refreshColor();
  }

  void _setAlphaValue(double value) {
    setState(() {
      _alphaValue = value;
    });
    _refreshColor();
  }

  void _setHexValue(String value) {
    final hexValue = value.replaceAll('#', '');
    final color = Color(int.parse('0xFF$hexValue'));
    setState(() {
      _redValue = (color.r * 255.0).clamp(0.0, 255.0);
      _greenValue = (color.g * 255.0).clamp(0.0, 255.0);
      _blueValue = (color.b * 255.0).clamp(0.0, 255.0);
      _refreshColor();
    });
  }

  void _refreshColor() {
    setState(() {
      _color = Color.fromRGBO(
        _redValue.toInt(),
        _greenValue.toInt(),
        _blueValue.toInt(),
        _alphaValue,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final currentColor = ref.read(bitmapProjectToolColorProvider);
    _redValue = currentColor.r;
    _greenValue = currentColor.g;
    _blueValue = currentColor.b;
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

    return Container(
      width: maxSize,
      height: maxSize,
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
                              color: _color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                BaseTheme.borderRadiusSmall,
                              ),
                              color: currentColor,
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
        ],
      ),
    );
  }
}
