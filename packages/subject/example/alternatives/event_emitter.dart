import 'package:subject/event_emitter.dart';

void main() {
  final events = EventEmitter();

  final listener = events.on('message', (String data) => print('String: $data'));
  events.on('message', (int data) => print('Integer: $data'));

  events.emit('message', 'Hello World!');
  events.emit('message', 42);

  listener.cancel();
  events.emit('message', 'Hello World, again!');

  // [Output]
  // String: Hello World!
  // Integer: 42
}
