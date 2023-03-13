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

  user.say('Hello world!');
  user.thought = 'I am thinking...';

  /* [Output]
    John says "Hello world!"
    User said "Hello world!"
    User thought "I am thinking..."
  */
}