import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

/// The notices of this session: what other members did in the group since
/// the app opened, newest first, and how many are still unread (#155).
///
/// Only the session: events are not stored on the server, so what happened
/// with the app closed is not here. Whether to keep them is #159.
class ActivityController extends ChangeNotifier {
  ActivityController({required this.myMemberId});

  /// Who is signed in, to leave their own actions out. A function because
  /// the group loads after this is made.
  final int? Function() myMemberId;

  /// Enough for a session; older ones drop off the end.
  static const maxItems = 100;

  final List<GroupEvent> _items = [];
  int _unreadCount = 0;

  List<GroupEvent> get items => List.unmodifiable(_items);
  int get unreadCount => _unreadCount;
  bool get hasUnread => _unreadCount > 0;

  /// Keeps [event] as a notice unless this member did it. Returns whether it
  /// was kept, so the caller can also show it live (#158).
  bool add(GroupEvent event) {
    final me = myMemberId();
    if (me != null && event.actorMemberId == me) return false;
    _items.insert(0, event);
    if (_items.length > maxItems) _items.removeLast();
    _unreadCount = (_unreadCount + 1).clamp(0, maxItems);
    notifyListeners();
    return true;
  }

  /// Called when the Activity screen opens.
  void markAllRead() {
    if (_unreadCount == 0) return;
    _unreadCount = 0;
    notifyListeners();
  }
}
