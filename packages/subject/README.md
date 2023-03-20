[![Pub.dev package](https://img.shields.io/badge/pub.dev-subject-blue?logo=dart)](https://pub.dev/packages/subject)
[![GitHub repository](https://img.shields.io/badge/GitHub-ObserverPattern--dart-blue?logo=github)](https://github.com/DrafaKiller/ObserverPattern-dart/tree/main/packages/subject)

# Observer Pattern - Subject

[Observer Pattern](https://en.wikipedia.org/wiki/Observer_pattern) implementation for Dart, using callbacks, streams and states.
Subject code generator with annotations, to automatically generate an observable interface for any class.

![](https://raw.githubusercontent.com/DrafaKiller/ObserverPattern-dart/tree/v1.0.0/packages/subject/assets/code_generation_example.png)

<p align="center">
  Use <code>dart run subject:build</code> to generate the code.<br>
  Click here to see how to setup the <a href="#code-generation">Code Generation</a>.
</p>

## Features

- Subject and Observer, as base implementation
- Callback, Stream, Sink and Stateful mixins, to extend the Subject and Observer classes
- Alternative implementations, such as **Publisher** and **EventEmitter**
- Code generation using `@subject` and `@observe`, to automatically generate an observable interface for any class

## Getting Started 

```
dart pub add subject
```

And import the package:

```dart
import 'package:subject/subject.dart';
```

## Basic Observer Pattern

The observer pattern is a software design pattern in which an object, called the subject, maintains a list of its dependents, called observers, and notifies them automatically of any state changes, usually by calling one of their methods.

You can create a subject and an observer, and attach the observer to the subject:

```dart
final subject = Subject<String>();

final observer = Observer<String>(
  (subject, state) => print('Observer Callback: $state')
);

subject.attach(observer);
```

Now, you can notify the subject to update the state and notify the observers:

```dart
subject.notify('Hello World!');
```

There are many ways to implement the observer pattern, and this package provides several implementations, which can be mixed into the subject and observer classes.

### Callback - `Observer`

```dart
final subject = Subject<String>();
final observer = Observer<String>((subject, state) => print('Observer: $state'));

subject.attach(observer);
subject.notify('Hello World!');
```

#### Async - `Subject.sink` / `Observer.stream`

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
- **StreamableSubject** - Transforms the subject into a stream, subscriptions are attached to the subject as auto disposable StreamObservers
- **SinkableSubject** - Transforms the subject into a sink, which notifies the subject when a value is added
- **SubjectState** - Allows the subject to have a persistent state

### Observer
- **Cancelable** - Allows the observer to be canceled, which will detach it from the subject
- **Callbackable** - Allows the observer to be instantiated with a callback
- **StreamableObserver** - Transforms the observer into a stream, which can be listened to
- **ObserverState** - Allows the observer to have a persistent state

## Code Generation

With the `@subject` and `@observe` annotations, you can generate an observable interface for any class automatically.
You can listen to methods calls, and changes in properties, using the `.on()` and `.onBefore()` methods.

Start the subject code generator by running the following command:
- `dart run subject:build` - Build once
- `dart run subject:watch` - Watch for changes and build


Or instead, use the following commands to continuously generate the code:
```
dart pub add subject_gen -d
dart run build_runner watch -d
```
Or, using Flutter:
```
flutter pub add subject_gen -d
flutter pub run build_runner watch -d
```

These commands will add the `subject_gen` package as a development dependency and run the builder with the `watch -d` command, or `build -d` for only once. You only need to add the package one time.

### Annotation `@subject`

By using the `@subject` annotation you can generate a subject class for the annotated class.
The generated class will be named `${className}Subject`, and a mixin named `Observable${className}`.

```dart
@subject
class User {
  final String name;

  User(this.name);

  void say(String message) => print('$name says "$message"');
}
```

The `@subject` annotation will create a `UserSubject` class that wraps all methods and properties in a `notify` call, making them observable.

You can use the `@dontObserve` annotation to exclude elements from the generated subject class.

### Annotation `@observe`

The `@observe` annotation is used to indicate which methods and properties should be observable in the generated subject class.

```dart
class User {
  final String name;

  User(this.name);

  @observe
  void say(String message) => print('$name says "$message"');
}
```

In the `User` class, only the `say` method is annotated with `@observe`, which means it will be the only observable element in the generated `UserSubject` class.
The other elements of the class will not be observable.

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
  <summary>Subject / Observer <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/main.dart">(View on GitHub)</a></summary>
    
  ```dart
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
  ```
</details>

<details>
  <summary>Code Generator <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/build.dart">(View on GitHub)</a></summary>
    
  ```dart
import 'package:subject/subject.dart';

part 'build.g.dart';

@subject
class User<T> {
  final String name;
  String? thought;

  @dontObserve
  T value;

  User(this.name, this.value);

  // @observe
  void say(String message) => print('$name says "$message"');
}

void main() {
  final user = UserSubject('John', 4);
  
  user.on(
    say: (message) => print('User said "$message"'),
    thought: (value, previous) => print('User thought "$value"'),
  );

  user.say('Hello World!');
  user.thought = 'I am thinking...';

  /* [Output]
    John says "Hello World!"
    User said "Hello World!"
    User thought "I am thinking..."
  */
}
  ```
</details>

<details>
  <summary>Extending <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/extending.dart">(View on GitHub)</a></summary>
    
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
  <summary>Sink / Stream <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/base/async.dart">(View on GitHub)</a></summary>
    
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
  <summary>Stateful <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/base/stateful.dart">(View on GitHub)</a></summary>
    
  ```dart
import 'package:subject/observer.dart';

/* -= Stateful - Subject =- */

void statefulSubject() {
  final subject = Subject.stateful<String>(notifyOnAttach: true);

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

  final observer = Observer.stateful<String>();
  subject.attach(observer);

  subject.notify('Hello World!');
  print('The state is "${ observer.state }"');

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
  <summary>Publisher <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/alternatives/publisher.dart">(View on GitHub)</a></summary>
    
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
  <summary>EventEmitter <a href="https://github.com/DrafaKiller/ObserverPattern-dart/blob/v1.0.0/packages/subject/example/alternatives/event_emitter.dart">(View on GitHub)</a></summary>
    
  ```dart
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
  ```
</details>


## Contributing

Contributions are welcome! Please open an [issue](https://github.com/DrafaKiller/ObserverPattern-dart/issues) or [pull request](https://github.com/DrafaKiller/ObserverPattern-dart/pulls) if you find a bug or have a feature request.
