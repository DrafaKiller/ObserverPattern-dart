import 'package:subject/observer.dart';
import 'package:subject/publisher.dart';

import 'callbacks.dart';
import 'emitter.dart';
import 'event.dart';
import 'target.dart';

class EventListener<T extends Event> extends Subscriber<Event> with EventTarget<T> {
  EventListener({
    this.type,
    EventDispatchCallback<T>? callback,

    this.protected = false,
    this.once = false,
    Function? alias,
  }) :
    alias = alias ?? callback,
    super((subject, event) => callback?.call(event as T));

  @override final String? type;

  @override final bool protected;
  @override final bool once;
  final Function? alias;

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
