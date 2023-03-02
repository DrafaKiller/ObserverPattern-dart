import 'package:observer/publisher.dart';

import 'callbacks.dart';
import 'event.dart';
import 'listener.dart';

class EventEmitter {
  final _publisher = Publisher<Event>();

  Set<EventListener> get listeners => _publisher.subscribers.cast();

  void addListener(EventListener listener) => _publisher.subscribe(listener);
  void removeListener(EventListener listener) => _publisher.unsubscribe(listener);

  /* -= Input =- */

  bool emit<T>(String type, [ T? data ]) => dispatch(data != null ? Event<T>(type, data) : Event(type, null));
  
  bool dispatch(Event event) {
    if (listeners.isEmpty) return false;
    _publisher.publish(event);

    event.resolve();
    return !event.isCanceled;
  }

  /* -= Output =- */

  EventListener<Event<T>> on<T>(String type, [ EventCallback<T>? callback ]) {
    final listener = EventListener<Event<T>>(
      type: type,
      callback: (event) => callback?.call(event.data),
      alias: callback
    );

    addListener(listener);
    return listener;
  }

  EventListener<Event<T>> once<T>(String type, [ EventCallback<T>? callback ]) {
    final listener = EventListener<Event<T>>(
      type: type,
      callback: (event) => callback?.call(event.data),
      alias: callback,
      once: true
    );
    
    addListener(listener);
    return listener;
  }

  EventListener<T> onDispatch<T extends Event>([ EventDispatchCallback<T>? callback ]) {
    final listener = EventListener<T>(callback: callback);
    addListener(listener);
    return listener;
  }

  bool off<T extends Event>({ String? type, EventCallback<T>? callback }) {
    bool removed = false;

    for (final listener in listeners.where((listener) => listener.matches<T>(type: type, protected: false))) {
      removed = listener.cancel() || removed;
    }

    return removed;
  }
}