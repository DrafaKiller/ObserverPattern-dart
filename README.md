[![Pub.dev package](https://img.shields.io/badge/pub.dev-subject-blue)](https://pub.dev/packages/subject)
[![GitHub repository](https://img.shields.io/badge/GitHub-ObserverPattern--dart-blue?logo=github)](https://github.com/DrafaKiller/ObserverPattern-dart)

# Observer Pattern - Subject

Observer Pattern implementation for Dart, using callbacks, streams and states.
Subject code generator with annotations, to automatically generate an observable interface for any class.

Alternative implementations are available, such as **Publisher** and **EventEmitter**.

## Features

- Subject and Observer, for base implementation
- Callback, Stream and Stateful mixins, to extend the Subject and Observer classes
- `@subject` and `@observe` annotations, to generate an observable interface for any class

## Getting Started 

```
dart pub add subject
```

And import the package:

```dart
import 'package:subject/subject.dart';
```

## Usage

Create a subject by initializing or extending **Subject**, you can set the type of the state that will be passed to the observers:

```dart
final subject = Subject<String>();
```

Create an observer and attach it to the subject.
An observer can be created using `Observer` or `Observer.stream`:

```dart
final observer = Observer<String>((subject, state) => print('Observer Callback: $state'));

final observerStream = Observer.stream<String>()..listen((state) => print('Observer Stream: $state'));

final observerCoupled = Observer.coupled<String>(
  attached: (subject, observer) => print('Observer Attached'),
  detached: (subject, observer) => print('Observer Detached'),
);

final observerStateful = Observer.stateful<String>();

subject.attach(observer);
subject.attach(observerStream);
```

Notify the subject to update the state and notify the observers:

```dart
subject.notify('Hello World!');
```

## Subjects and Observers

You have different bases to create a subject and observer, each with its features:

### Callback - `Observer`

```dart
final subject = Subject<String>();
final observer = Observer<String>((subject, state) => print('Observer: $state'));

subject.attach(observer);
subject.notify('Hello World!');
```

### Async  - `Subject.sink` / `Observer.stream`

```dart
final subject = Subject.sink<String>(sync: true);
final observer = Observer.stream<String>(sync: true);

observer.listen((state) => print('Observer: $state'));

subject.attach(observer);
subject.add('Hello World!');
```

### Coupled - `Observer.coupled`

```dart
final subject = Subject<String>();
final observer = Observer.coupled<String>(
  attached: (subject, observer) => print('Observer Attached'),
  detached: (subject, observer) => print('Observer Detached'),
);

subject.attach(observer);
subject.notify('Hello World!');
```

### Stateful - `Subject.stateful` / `Observer.stateful`

```dart
final subject = Subject.stateful<String>(state: 'Initial State', notifyOnAttach: true);
final observer = Observer.stateful<String>();

subject.attach(observer);
subject.notify('Hello World!');

print('Subject State: ${subject.state}');
```

## Mixins

You can create your own subject and observer classes, by extending the base classes and mixing the desired features:

### Subject
- **StreamableSubject** - Transforms the subject into a stream, subscriptions are plugged into the subject as **StreamObserver**s
- **SinkableSubject** - Transforms the subject into a sink, which notifies the subject when a value is added
- **SubjectState** - Allows the subject to have a persistent state

### Observer
- **Callbackable** - Allows the observer to be instantiated with a callback
- **StreamableObserver** - Transforms the observer into a stream, which can be listened to
- **ObserverState** - Allows the observer to have a persistent state
- **Cancelable** - Allows the observer to be canceled, which will detach it from the subject

## Code Generation

With the `@subject` and `@observe` annotations, you can generate an observable interface for any class automatically.
You can listen to methods calls, and changes in properties, using the `.on()` and `.onBefore()` methods.

### Annotation `@subject`

By using the `@subject` annotation, you can create a subject class that generates an observable interface for the annotated class.
The generated class will be named `${className}Subject`.

```dart
@subject
class User {
  final String name;
  String? thought;

  User(this.name);

  void say(String message) => print('$name says "$message"');
}
```

The `@subject` annotation will create a `UserSubject` class that wraps all the annotated methods and properties in a `notify` call, making them observable.

### Annotation `@observe`

The `@observe` annotation is used to indicate which methods and properties should be wrapped when generating the observable interface.
You can use it to specify which elements should be observable and which should not.

```dart
class User {
  final String name;
  String? thought;

  User(this.name);

  @observe
  void say(String message) => print('$name says "$message"');
}
```

In the `User` class, only the `say` method is annotated with `@observe`, which means only it will be observable in the generated `UserSubject` class.
The other elements of the class will not be included in the generated class.

The `@observe` annotation overrides the `@subject` annotation, so if you use both, only the elements annotated with `@observe` will be observable.

### Listening to events

To listen to events, you can use the `.on()` and `.onBefore()` methods, which are included in the generated subject class.
The `.on()` method contains all the generated methods and setters, making it easy to listen to events for the annotated class.

```dart
final user = UserSubject('John');

user.on(
  say: (message) => print('User said "$message"'),
);
```

## Example

<details open>
  <summary>Subject / Observer <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/main.dart">(GitHub)</a></summary>
    
  ```dart
import 'package:subject/observer.dart';

void main() {
  final subject = Subject<String>();

  final observer = Observer<String>((subject, state) => print('Observer 1: $state'));

  subject.attach(observer);
  subject.attach(Observer((subject, state) => print('Observer 2: $state')));
  subject.attach(Observer.stream()..listen((state) => print('Observer 3: $state')));

  subject.notify('Hello World!');
  print('There are ${subject.observers.length} observers attached to the subject.');

  subject.detach(observer);
  subject.notify('Hello World, again!');

  /* [Output]
    Observer 1: Hello World!
    Observer 2: Hello World!
    Observer 3: Hello World!

    There are 3 observers attached to the subject.

    Observer 2: Hello World, again!
    Observer 3: Hello World, again!
  */
}
  ```
</details>

<details>
  <summary>Code Generator <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/build.dart">(GitHub)</a></summary>
    
  ```dart
import 'package:subject/subject.dart';

part 'subject.g.dart';

@subject
class User<T> {
  final String name;

  String? thought;
  T value;

  User(this.name, this.value);

  // @observe
  void say(String message) => print('$name says "$message"');
}

void main() {
  final user = UserSubject('John', 4);
  
  user.on(
    say: (message) => print('User said "$message"'),
  );

  user.say('Hello world');

  /* [Output]
    John says "Hello world"
    User said "Hello world"
  */
}
  ```
</details>

<details>
  <summary>Extending <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/extending.dart">(GitHub)</a></summary>
    
  ```dart
import 'package:subject/observer.dart';

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
  <summary>Sink / Stream <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/base/async.dart">(GitHub)</a></summary>
    
  ```dart
import 'package:subject/observer.dart';

void main() {
  final subject = Subject.sink<String>();
  
  final observer = Observer.stream<String>();
  observer.listen((message) => print('Observer: "$message"'));
  
  subject.attach(observer);
  subject.add('Hello World!');

  /* [Output]
    Observer: "Hello World!"
  */
}
  ```
</details>

<details>
  <summary>Stateful <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/base/stateful.dart">(GitHub)</a></summary>
    
  ```dart
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
  ```
</details>

<details>
  <summary>Publisher <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/alternatives/publisher.dart">(GitHub)</a></summary>
    
  ```dart
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
  ```
</details>

<details>
  <summary>EventEmitter <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/main/example/alternatives/event_emitter.dart">(GitHub)</a></summary>
    
  ```dart
import 'package:subject/event_emitter.dart';

void main() {
  final events = EventEmitter();

  final listener = events.on('message', (String data) => print('String: $data'));
  events.on('message', (int data) => print('Integer: $data'));

  listener.listen((event) => print('Event: $event'));

  events.emit('message', 'Hello World');
  events.emit('message', 42);

  // [Output]
  // String: Hello World
  // Integer: 42
}
  ```
</details>


## Contributing

Contributions are welcome! Please open an [issue](https://github.com/DrafaKiller/ObserverPattern-dart/issues) or [pull request](https://github.com/DrafaKiller/ObserverPattern-dart/pulls) if you find a bug or have a feature request.
