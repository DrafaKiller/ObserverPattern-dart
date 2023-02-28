import 'dart:async';












class Event<Data> {
  final String type;
  final Data data;

  Event(this.type, this.data);
}

class EventListener<T extends Event> extends Subscriber<T> {
  final String? type;

  EventListener(this.type);
  
}

class EventEmitter {
  final _publisher = Publisher<Event>();

  Set<EventListener> get listeners => _publisher.subscribers;
}




