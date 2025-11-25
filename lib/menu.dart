import 'package:flutter/material.dart';

import 'bitmap_projects/new.dart';
import 'ui/scaffold.dart';
import 'ui/theme.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      showLogo: true,
      child: Builder(
        builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                FilledButton(
                  onPressed: () {
                    final scaffold = UIScaffold.of(context);
                    scaffold.showOverlay(
                      NewBitmapProjectOverlay(
                        onClose: () => scaffold.hideOverlay(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: BaseColors.primaryContainerColor,
                    foregroundColor: BaseColors.primaryContainerContrastColor,
                  ),
                  child: const Text('New Project'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
