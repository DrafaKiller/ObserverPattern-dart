import 'package:observer/src/observer.dart';
import 'package:observer/src/mixins/stateful.dart';

class StatefulObserver<State> with Observer<State>, ObserverState<State> {
  StatefulObserver();
}