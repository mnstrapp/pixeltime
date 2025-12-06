import 'package:flutter/material.dart';

abstract class HistoryEvent {
  final Future<(bool, String?)> Function() onExecute;
  final Future<(bool, String?)> Function() onUndo;

  HistoryEvent({required this.onExecute, required this.onUndo});

  Future<(bool, String?)> execute() async {
    return await onExecute();
  }

  Future<(bool, String?)> undo() async {
    return await onUndo();
  }
}

const logHeader = '[History]';

class History {
  final List<HistoryEvent> events = [];
  final List<HistoryEvent> undoneEvents = [];

  Future<(bool, String?)> add(HistoryEvent event) async {
    final (_, error) = await event.execute();
    if (error != null) {
      debugPrint('$logHeader Error executing event: $error');
      return (false, error);
    }
    debugPrint('$logHeader Adding event: $event');
    events.add(event);
    return (true, null);
  }

  Future<(bool, String?)> undo() async {
    if (events.isEmpty) {
      debugPrint('$logHeader No events to undo');
      return (false, 'No events to undo');
    }
    final event = events.removeLast();
    final (_, error) = await event.undo();
    if (error != null) {
      debugPrint('$logHeader Error undoing event: $error');
      return (false, error);
    }
    debugPrint('$logHeader Undoing event: $event');
    undoneEvents.add(event);
    return (true, null);
  }

  Future<(bool, String?)> redo() async {
    if (undoneEvents.isEmpty) {
      debugPrint('$logHeader No events to redo');
      return (false, 'No events to redo');
    }
    final event = undoneEvents.removeLast();
    final (_, error) = await event.execute();
    if (error != null) {
      debugPrint('$logHeader Error executing event: $error');
      return (false, error);
    }
    debugPrint('$logHeader Redoing event: $event');
    events.add(event);
    return (true, null);
  }

  bool get canUndo => events.isNotEmpty;
  bool get canRedo => undoneEvents.isNotEmpty;
}
