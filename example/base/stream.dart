import 'package:subject/observer.dart';

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