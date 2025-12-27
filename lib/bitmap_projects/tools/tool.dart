enum BitmapProjectToolType {
  select,
  pencil,
  eraser,
  fill,
}

extension BitmapProjectToolTypeExtension on BitmapProjectToolType {
  String get name {
    switch (this) {
      case BitmapProjectToolType.select:
        return 'Select';
      case BitmapProjectToolType.pencil:
        return 'Pencil';
      case BitmapProjectToolType.eraser:
        return 'Eraser';
      case BitmapProjectToolType.fill:
        return 'Fill';
    }
  }
}

class BitmapProjectTool {
  final BitmapProjectToolType type;
  final List<BitmapProjectToolOption> options;

  BitmapProjectTool({
    required this.type,
    required this.options,
  });
}

class BitmapProjectToolOption {
  final String name;

  BitmapProjectToolOption({
    required this.name,
  });
}
