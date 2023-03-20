import 'package:subject/publisher.dart';

void main() {
  final publisher = Publisher<String>();

  final subscriber = Subscriber<String>((subject, message) => print('Callback: "$message"'));
  publisher.subscribe(subscriber);
  publisher.subscribe(Subscriber<String>()..listen((message) => print('Stream: "$message"')));

  publisher.publish('Hello World!');

  print('There are ${ publisher.subscribers.length } subscribers attached to the publisher.');

  subscriber.cancel();
  publisher.publish('Hello World, again!');

  /* [Output]
    Callback: "Hello World!"
    Stream: "Hello World!"

    There are 2 subscribers attached to the publisher.

    Stream: "Hello World, again!"
  */
}
