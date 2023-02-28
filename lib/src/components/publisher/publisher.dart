import 'subscriber.dart';

class Publisher<Context> {
  final subscribers = <Subscriber<Context>>{};

  void subscribe(Subscriber<Context> subscriber) {
    subscribers.add(subscriber);
    subscriber.onCancel.then((_) => unsubscribe(subscriber));
  }
  void unsubscribe(Subscriber<Context> subscriber) => subscribers.remove(subscriber);

  void notify(Context context) {
    for (final subscriber in subscribers) {
      subscriber.update(context);
    }
  }
}