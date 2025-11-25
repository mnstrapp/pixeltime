import 'package:flutter/material.dart';

import 'menu.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: BaseTheme.themeData,
      home: const MenuScreen(),
    );
  }
}
