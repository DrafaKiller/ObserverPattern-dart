import 'dart:async';

import 'package:observer/observer.dart';

mixin Cancelable<State> on Observer<State> implements CoupledObserver<State> {
  final _completer = Completer<void>.sync();

  Future<void> get onCancel => _completer.future;
  bool get canceled => _completer.isCompleted;

  bool cancel() {
    final wasCanceled = canceled;
    if (!canceled) _completer.complete();
    return wasCanceled != canceled;
  }

  /* -= Observer - Coupled =- */

  @override
  void attach(Subject<State> subject) {
    onCancel.then((_) {
      if (subject.observers.contains(this)) subject.detach(this);
    });
  }

  @override
  void detach(Subject<State> subject) => cancel();
}