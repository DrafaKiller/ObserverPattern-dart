import 'dart:collection';

import 'observer.dart';

class Subject<State> {
  final _observers = <Observer<State>>[];
  List<Observer<State>> get observers => UnmodifiableListView(_observers);

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
