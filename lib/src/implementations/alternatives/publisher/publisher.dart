// Programming Pattern: https://en.wikipedia.org/wiki/Publish–subscribe_pattern

import 'package:observer/src/subject.dart';

import 'subscriber.dart';

class Publisher<Message> {
  final _subject = Subject<Message>();

  List<Subscriber<Message>> get subscribers => _subject.observers.cast();

  void publish(Message message) => _subject.notify(message);

  void subscribe(Subscriber<Message> subscriber) => _subject.attach(subscriber);
  void unsubscribe(Subscriber<Message> subscriber) => _subject.detach(subscriber);
}
