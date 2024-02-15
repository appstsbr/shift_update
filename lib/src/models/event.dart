import './event_type.dart';
import './user.dart';
import './user_activity.dart';

class Event {
  final UserActivity? userActivity;
  final User? user;
  final EventType? type;

  Event({required this.userActivity, required this.user, required this.type});

  factory Event.fromJson(EventType type, User user, UserActivity userActivity) {
    return new Event(
      userActivity: userActivity,
      user: user,
      type: type,
    );
  }

  UserActivity get eventUserActivity => userActivity!;
  User get eventUser => user!;
  EventType get eventType => type!;
}
