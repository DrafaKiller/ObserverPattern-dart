import 'dart:collection';

import 'package:subject/src/mixins/callbackable.dart';

import 'implementations/base/callback.dart';
import 'implementations/base/stateful.dart';
import 'implementations/base/stream.dart';
import 'subject.dart';

/* -= Uncoupled Observer =- */

abstract class Observer<State> {
  void update(Subject<State> subject, State state) {}

  /* -= Alternative Implementations =- */

  factory Observer(ObserverCallback<State> callback) = CallbackObserver<State>;
  
  factory Observer.coupled({
    CoupledObserverCallback<State>? attached,
    CoupledObserverCallback<State>? detached
  }) = CallbackCoupledObserver<State>;

  static StreamObserver<State> stream<State>() => StreamObserver<State>();

  static StatefulObserver<State> stateful<State>() => StatefulObserver<State>();
}

/* -= Coupled Observer =- */

abstract class CoupledObserver<State> implements Observer<State> {
  final _subjects = <Subject<State>>[];
  List<Subject<State>> get subjects => UnmodifiableListView(_subjects);
  
  @override
  void update(Subject<State> subject, State state) {}

  void attached(Subject<State> subject) => _subjects.add(subject);
  void detached(Subject<State> subject) => _subjects.remove(subject);
}