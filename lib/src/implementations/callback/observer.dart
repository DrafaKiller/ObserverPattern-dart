import 'package:observer/src/observer.dart';
import 'package:observer/src/mixins/callable.dart';

class CallbackObserver<State> with Observer<State>, Callable<State> {
  @override 
  final ObserverCallback<State>? callback;

  CallbackObserver([ this.callback ]);
}