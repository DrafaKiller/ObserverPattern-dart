import 'package:observer/src/observer.dart';

import '../subject.dart';

mixin SubjectState<State> on Subject<State> {
  bool get notifyOnAttach;

  /* -= State =- */

  late State _state;
  State get state => _state;
  set state(State state) => notify(state);
  
  /* -= Subject =- */

  @override
  void attach(Observer<State> observer) {
    super.attach(observer);
    if (notifyOnAttach) observer.update(this, state);
  }

  @override
  void notify(State state) {
    _state = state;
    super.notify(state);
  }
}

mixin ObserverState<State> on Observer<State> {
  State? _state;
  State? get state => _state;
  
  /* -= Observer =- */

  @override
  void update(Subject<State> subject, State state) {
    _state = state;
    super.update(subject, state);
  }
}