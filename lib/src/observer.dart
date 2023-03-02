import 'dart:collection';

import 'package:observer/src/implementations/base/stream.dart';
import 'package:observer/src/mixins/callable.dart';

import 'implementations/base/callback.dart';
import 'subject.dart';

/* -= Uncoupled Observer =- */

abstract class Observer<State> {
  void update(Subject<State> subject, State state) {}

  factory Observer(ObserverCallback<State> callback) = CallbackObserver<State>;
  static StreamObserver<State> stream<State>() => StreamObserver<State>();
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