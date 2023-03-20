// Programming Pattern: https://en.wikipedia.org/wiki/Publish–subscribe_pattern

import 'package:subject/src/subject.dart';

import 'subscriber.dart';

/// ## Observer Pattern - `Publisher`
/// 
/// - A `Publisher` is a subject that publishes messages to subscribers.
/// - A `Subscriber` is an observer that subscribes to a publisher.
/// 
/// Subscribers can be notified when a message is published.
class Publisher<Message> {
  final _subject = Subject<Message>();

  /// List of subscribers to be notified when a message is published.
  List<Subscriber<Message>> get subscribers => _subject.observers.cast();

  /// Publishes a message to all subscribers.
  void publish(Message message) => _subject.notify(message);

  /// Subscribes a subscriber to this publisher.
  /// 
  /// The subscriber will be notified when a message is published.
  void subscribe(Subscriber<Message> subscriber) => _subject.attach(subscriber);

  /// Unsubscribes a subscriber from this publisher.
  /// 
  /// The subscriber will no longer be notified when a message is published.
  void unsubscribe(Subscriber<Message> subscriber) => _subject.detach(subscriber);
}
