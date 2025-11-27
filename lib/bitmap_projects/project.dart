import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bitmap_project.dart';

class BitmapProjectScreen extends ConsumerWidget {
  final BitmapProject project;
  const BitmapProjectScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: Text(project.name));
  }
}
