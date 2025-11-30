import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/bitmap_project.dart';
import '../ui/theme.dart';

class RecentProjectTile extends StatelessWidget {
  final BitmapProject project;
  final VoidCallback? onTap;
  const RecentProjectTile({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final updatedAt = DateTime.parse(project.updatedAt!);
    final lastUpdated = timeago.format(updatedAt);
    return Container(
      margin: EdgeInsets.all(BaseTheme.borderRadiusSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(BaseTheme.borderRadiusSmall),
      ),
      child: ListTile(
        title: Text(project.name),
        subtitle: project.updatedAt != null ? Text(lastUpdated) : null,
        trailing: Icon(Icons.file_open),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
