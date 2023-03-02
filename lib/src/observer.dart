import 'package:observer/src/mixins/callable.dart';

import 'implementations/base/callback/observer.dart';
import 'implementations/base/stream/observer.dart';
import 'subject.dart';

abstract class Observer<State> {
  void update(Subject<State> subject, State state) {}

  factory Observer(ObserverCallback<State> callback) = CallbackObserver<State>;
  static StreamObserver<State> stream<State>() => StreamObserver<State>();
}

abstract class CoupledObserver<State> implements Observer<State> {
  void attach(Subject<State> subject);
  void detach(Subject<State> subject);
}