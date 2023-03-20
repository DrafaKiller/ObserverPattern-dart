import 'package:subject/observer.dart';

void main() {
  final subject = Subject<String>();

  final observer = Observer<String>((subject, state) => print('Observer 1: $state'));
  final streamObserver = Observer.stream<String>()..listen((state) => print('Observer 2: $state'));

  subject.attach(observer);
  subject.attach(streamObserver);

  subject.notify('Hello World!');
  print('There are ${subject.observers.length} observers attached to the subject.');

  print('Detaching observer...');
  subject.detach(observer);

  subject.notify('Hello World, again!');

  /* [Output]
    Observer 1: Hello World!
    Observer 2: Hello World!

    There are 2 observers attached to the subject.
    Detaching observer...

    Observer 2: Hello World, again!
  */
}
