[![Pub.dev package](https://img.shields.io/badge/pub.dev-package__name-blue)](https://pub.dev/packages/subject)
[![GitHub repository](https://img.shields.io/badge/GitHub-Subject--dart-blue?logo=github)](https://github.com/DrafaKiller/Subject-dart)

# Observer Pattern

Observer Pattern implementation for Dart. Generalized solutions using callbacks, streams and states.

## Features

- A list of features provided by the package
- More...

## Getting Started 

```
dart pub add subject
```

And import the package:

```dart
import 'package:subject/subject.dart';
```

## Usage

Explanation of how to use the package...

```dart
// How to use the features of the package...
// Divided into sections.
```

## Example

```dart
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
```

<details>
  <summary>Extending <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/extending.dart"><code>(/example/extending.dart)</code></a></summary>
    
  ```dart
import 'package:observer/observer.dart';

class User extends Subject<String> {
  final String name;

  User(this.name);
  
  void say(String message) {
    print(message);
    notify(message);
  }
}

class UserObserver with Observer<String> {
  @override
  void update(Subject<String> subject, String message) {
    if (subject is! User) return;
    print('${ subject.name } says "$message"');
  }
}

void main() {
  final user = User('John');
  user.attach(UserObserver());

  user.say('Hello World!');

  /* [Output]
    Hello World!
    John says "Hello World!"
  */
}
  ```
</details>

<details>
  <summary>Stream Observer <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/stream.dart"><code>(/example/stream.dart)</code></a></summary>
    
  ```dart
import 'package:observer/observer.dart';

void main() {
  final subject = Subject<String>();
  
  final observer = Observer.stream<String>();
  observer.listen((message) => print('Observer: "$message"'));
  
  subject.attach(observer);
  subject.notify('Hello World!');

  /* [Output]
    Observer: "Hello World!"
  */
}
  ```
</details>

<details>
  <summary>Stateful <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/stateful.dart"><code>(/example/stateful.dart)</code></a></summary>
    
  ```dart
import 'package:observer/observer.dart';

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
  ```
</details>

<details>
  <summary>Publisher <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/alternatives/publisher.dart"><code>(/example/alternatives/publisher.dart)</code></a></summary>
    
  ```dart
import 'package:observer/publisher.dart';

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
  ```
</details>


## Contributing

Contributions are welcome! Please open an [issue](https://github.com/DrafaKiller/ObserverPattern-dart/issues) or [pull request](https://github.com/DrafaKiller/ObserverPattern-dart/pulls) if you find a bug or have a feature request.
