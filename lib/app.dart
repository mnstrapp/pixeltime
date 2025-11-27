import 'package:flutter/material.dart';

import 'ui/theme.dart';
import 'workspace/workspace.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: BaseTheme.themeData,
      darkTheme: BaseTheme.darkThemeData,
      home: const Workspace(),
    );
  }
}
