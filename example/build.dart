import 'package:subject/subject.dart';

part 'build.g.dart';

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