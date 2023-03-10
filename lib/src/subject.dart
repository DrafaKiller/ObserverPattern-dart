import 'dart:collection';

import 'package:subject/observer.dart';

import 'implementations/base/sink.dart';

class Subject<State> {
  final _observers = <Observer<State>>[];
  List<Observer<State>> get observers => UnmodifiableListView(_observers);

  /* -= Alternative Implementations =- */
    
  static StreamSubject<State> stream<State>({ bool sync = true }) => StreamSubject<State>(sync: sync);

  static SinkSubject<State> sink<State>() => SinkSubject<State>();

  static StatefulSubject<State> stateful<State>({ State? state, bool notifyOnAttach = false }) =>
    StatefulSubject<State>(state: state, notifyOnAttach: notifyOnAttach);

  /* -= Methods =- */

  void attach(Observer<State> observer) {
    _observers.add(observer);
    if (observer is CoupledObserver<State>) observer.attached(this);
  }

  void detach(Observer<State> observer) {
    _observers.remove(observer);
    if (observer is CoupledObserver<State>) observer.detached(this);
  }

  void notify(State state) {
    for (final observer in observers) {
      observer.update(this, state);
    }
  }
}
