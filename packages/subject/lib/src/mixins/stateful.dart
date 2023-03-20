import 'package:subject/src/observer.dart';

import '../subject.dart';

mixin SubjectState<State> on Subject<State> {
  /// Whether the observer should be notified when it is attached to the subject.
  bool get notifyOnAttach;

  /* -= State =- */

  late State _state;

  /// The current state of the subject.
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

  /// The current state of the subject.
  State? get state => _state;
  
  /* -= Observer =- */

  @override
  void update(Subject<State> subject, State state) {
    _state = state;
    super.update(subject, state);
  }
}
