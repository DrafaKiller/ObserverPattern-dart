import 'package:subject/src/observer.dart';
import 'package:subject/src/mixins/callable.dart';

class CallbackObserver<State> with Observer<State>, Callable<State> {
  @override 
  final ObserverCallback<State>? callback;

  CallbackObserver([ this.callback ]);
}