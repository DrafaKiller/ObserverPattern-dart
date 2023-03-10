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