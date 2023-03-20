import 'dart:async';

import '../../observer.dart';
import '../../subject.dart';

/* -= Subject =- */

mixin StreamableSubject<State> on Subject<State> implements Stream<State> {
  late final StreamController<State> _controller = StreamController<State>.broadcast(sync: sync);

  /// Whether the stream is synchronous.
  bool get sync => true;

  /* -= Subject =- */

  @override
  void notify(State state) {
    super.notify(state);
    _controller.add(state);
  }

  /* -= Stream =- */

  @override
  StreamSubscription<State> listen(void Function(State event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final observer = Observer.stream<State>(sync: sync, autoDispose: true);
    attach(observer);
    return observer.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

/* -= Observer =- */

mixin StreamableObserver<State> on CoupledObserver<State> implements Stream<State> {
  /// Whether the stream is synchronous.
  bool get sync => true;

  /// Whether the observer should be detached from the subject when the stream is closed.
  bool get autoDispose => false;

  late final StreamController<State> _controller = StreamController<State>.broadcast(
    sync: sync,
    onCancel: () {
      if (autoDispose) {
        for (final subject in subjects) {
          subject.detach(this);
        }
      }
    },
  );

  /* -= Observer =- */

  @override
  void update(Subject<State> subject, State state) {
    super.update(subject, state);
    _controller.add(state);
  }

  @override
  void detached(Subject<State> subject) {
    super.detached(subject);
    _controller.close();
  }

  /* -= Stream =- */

  @override
  StreamSubscription<State> listen(
    void Function(State event)? onData,
    {
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError,
    }
  ) => _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
