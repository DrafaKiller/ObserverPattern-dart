import 'package:observer/observer.dart';

mixin Callable<State> on Observer<State> {
  ObserverCallback<State>? get callback;

  void call(Subject<State> subject, State state) => callback?.call(subject, state);

  /* -= Observer =- */

  @override
  void update(Subject<State> subject, State state) {
    this(subject, state);
  }
}

typedef ObserverCallback<State> = void Function(Subject<State> subject, State state);