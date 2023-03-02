import 'package:observer/publisher.dart';

import 'callbacks.dart';
import 'event.dart';
import 'listener.dart';

class EventEmitter {
  final _publisher = Publisher<Event>();

  List<EventListener> get listeners => _publisher.subscribers.cast();

  void addEventListener(EventListener listener) => _publisher.subscribe(listener);
  void removeEventListener(EventListener listener) => _publisher.unsubscribe(listener);

  /* -= Input =- */

  bool emit<T>(String type, [ T? data ]) => dispatch(data != null ? Event<T>(type, data) : Event(type, null));
  
  bool dispatch(Event event) {
    if (listeners.isEmpty) return false;
    _publisher.publish(event);

    event.resolve();
    return !event.isCanceled;
  }

  /* -= Output =- */

  EventListener<Event<T>> on<T>(String? type, [ EventCallback<T>? callback ]) {
    final listener = EventListener<Event<T>>(
      type: type,
      callback: (event) => callback?.call(event.data),
      alias: callback
    );

    addEventListener(listener);
    return listener;
  }

  EventListener<Event<T>> once<T>(String? type, [ EventCallback<T>? callback ]) {
    final listener = EventListener<Event<T>>(
      type: type,
      callback: (event) => callback?.call(event.data),
      alias: callback,
      once: true
    );
    
    addEventListener(listener);
    return listener;
  }

  EventListener<Event<T>> onDispatch<T>([ EventCallback<T>? callback ]) => on(null, callback);

  bool off<T extends Event>({ String? type, EventCallback<T>? callback }) {
    bool removed = false;

    for (final listener in listeners.where(
      (listener) => listener.matches<T>(type: type, protected: false) || (callback != null && listener.alias == callback)
    )) {
      removed = listener.cancel() || removed;
    }

    return removed;
  }
}