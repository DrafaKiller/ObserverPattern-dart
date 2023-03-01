import 'observer.dart';

class Subject<State> {
  final observers = <Observer<State>>{};

  void attach(Observer<State> observer) {
    observers.add(observer);
    if (observer is CoupledObserver<State>) observer.attach(this);
  }

  void detach(Observer<State> observer) {
    observers.remove(observer);
    if (observer is CoupledObserver<State>) observer.detach(this);
  }

  void notify(State state) {
    for (final observer in observers) {
      observer.update(this, state);
    }
  }
}