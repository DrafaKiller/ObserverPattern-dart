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