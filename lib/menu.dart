import 'package:flutter/material.dart';

import 'bitmap_projects/new.dart';
import 'ui/overlay_content.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _overlayController = OverlayPortalController();
  Widget? _overlayContent;

  void _showOverlay(Widget content) {
    setState(() {
      _overlayContent = OverlayContent(
        onClose: () => _hideOverlay(),
        child: content,
      );
    });
    _overlayController.show();
  }

  void _hideOverlay() {
    setState(() {
      _overlayContent = null;
    });
    _overlayController.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/loading_figure.png',
                width: 256,
                height: 256,
              ),
            ),
          ),
          OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (context) => _overlayContent!,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () => _showOverlay(
                  NewBitmapProjectOverlay(onClose: () => _hideOverlay()),
                ),
                child: const Text('New Project'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
