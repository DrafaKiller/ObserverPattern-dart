import 'package:observer/observer.dart';
import 'package:observer/publisher.dart';

import 'callbacks.dart';
import 'emitter.dart';
import 'event.dart';
import 'target.dart';

class EventListener<T extends Event> extends Subscriber<Event> with EventTarget<T> {
  @override final String? type;

  @override final bool protected;
  @override final bool once;
  final Function? alias;

  EventListener({
    this.type,
    EventDispatchCallback<T>? callback,

    this.protected = false,
    this.once = false,
    Function? alias
  }) :
    alias = alias ?? callback,
    super((subject, event) => callback?.call(event as T));

  /* -= Subscriber =- */

  @override
  void update(Subject<Event> subject, Event state) {
    if (nested) state = state.nested;

    if (accepts(state)) {
      super.update(subject, state);
      if (once) cancel();
    }
  }
}

extension EventListenerAddTo<T extends Event, This extends EventListener<T>> on This {
  This addTo(EventEmitter emitter) {
    emitter.addEventListener(this);
    return this;
  }
}
