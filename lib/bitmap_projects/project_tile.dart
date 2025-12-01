import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/bitmap_project.dart';
import '../ui/theme.dart';

class BitmapProjectTile extends StatelessWidget {
  final BitmapProject project;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BitmapProjectTile({
    super.key,
    required this.project,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onTap != null)
              InkWell(onTap: onTap, child: Icon(Icons.file_open)),
            if (onEdit != null) InkWell(onTap: onEdit, child: Icon(Icons.edit)),
            if (onDelete != null)
              InkWell(onTap: onDelete, child: Icon(Icons.delete)),
          ],
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
