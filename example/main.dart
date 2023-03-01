import 'package:observer/observer.dart';

void main() {
  final subject = Subject<String>();

  final observer = Observer<String>((subject, state) => print('Observer: $state'));

  subject.attach(observer);
  subject.attach(Observer((subject, state) => print('Observer 1: $state')));
  subject.attach(Observer.stream()..listen((state) => print('Observer 2: $state')));

  subject.notify('Hello World!');
  print('There are ${subject.observers.length} observers attached to the subject.');

  subject.detach(observer);
  subject.notify('Hello World, again!');

  /* [Output]
    Observer: Hello World!
    Observer 1: Hello World!
    Observer 2: Hello World!

    There are 3 observers attached to the subject.

    Observer 1: Hello World, again!
    Observer 2: Hello World, again!
  */
}