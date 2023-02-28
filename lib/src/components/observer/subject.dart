// Programming Pattern Documentation: https://en.wikipedia.org/wiki/Observer_pattern

import 'observer.dart';

class Subject<State> {
  final observers = <Observer<State>>{};

  void attach(Observer<State> observer) => observers.add(observer);
  void detach(Observer<State> observer) => observers.remove(observer);

  void notify(State state) {
    for (final observer in observers) {
      observer(state);
    }
  }
}

class PresistentSubject<State> extends Subject<State> {
  late State _state;

  PresistentSubject({ State? state }) {
    if (state != null) this.state = state;
  }

  State get state => _state;
  set state(State state) => notify(state);

  @override
  void notify(State state) {
    _state = state;
    super.notify(state);
  }
}