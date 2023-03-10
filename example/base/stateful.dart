import 'package:subject/observer.dart';

/* -= Stateful - Subject =- */

void statefulSubject() {
  final subject = StatefulSubject<String>(notifyOnAttach: true);

  subject.notify('Hello World!');
  subject.attach(Observer((subject, state) => print('Observer: "$state"')));

  print('The state is "${ subject.state }"');

  /* [Output]
    Observer: "Hello World!"
    The state is "Hello World!"
  */
}

/* -= Stateful - Observer =- */

void statefulObserver() {
  final subject = Subject<String>();

  final stateful = StatefulObserver<String>();
  subject.attach(stateful);

  subject.notify('Hello World!');
  print('The state is "${ stateful.state }"');

  /* [Output]
    The state is "Hello World!"
  */
}

void main() {
  print('[Stateful Subject]');
  statefulSubject();

  print('');
  print('[Stateful Observer]');
  statefulObserver();
}