import 'package:observer/src/utils/types.dart';

import 'event.dart';

mixin EventTarget<T extends Event> {
  String? get type;

  bool get protected => false;
  bool get once => false;
  bool get nested => isAssignable<T, Event<Event>>();

  bool matches<S extends Event>({
    String? type,
    bool? protected,
    bool? once,
  }) =>
    isAssignable<S, T>() &&
    (this.type == null || this.type == type) && 
    (protected == null || this.protected == protected) && 
    (once == null || this.once == once);

  bool accepts(Event event) =>
    event is T && !event.isCanceled &&
    (type == null || type == event.type);
}