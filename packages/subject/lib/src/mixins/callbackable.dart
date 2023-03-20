import 'package:subject/observer.dart';

mixin Callbackable<State> on Observer<State> {
  /// The callback to be executed when a new state is notified by the subject.
  ObserverCallback<State>? get callback;

  void call(Subject<State> subject, State state) => callback?.call(subject, state);

  /* -= Observer =- */

  @override
  void update(Subject<State> subject, State state) {
    super.update(subject, state);
    this(subject, state);
  }
}

/* -= Callback Definitions =- */

typedef ObserverCallback<State> = void Function(Subject<State> subject, State state);
