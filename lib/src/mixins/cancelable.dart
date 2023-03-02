import 'dart:async';

import 'package:observer/observer.dart';

mixin Cancelable<State> on CoupledObserver<State> {
  final _completer = Completer<void>.sync();

  Future<void> get onCancel => _completer.future;
  bool get isCanceled => _completer.isCompleted;

  bool cancel() {
    final wasCanceled = isCanceled;
    if (!isCanceled) _completer.complete();
    return wasCanceled != isCanceled;
  }

  /* -= Observer - Coupled =- */

  @override
  void attached(Subject<State> subject) {
    super.attached(subject);
    onCancel.then((_) {
      if (subject.observers.contains(this)) subject.detach(this);
    });
  }

  @override
  void detached(Subject<State> subject) {
    super.detached(subject);
    cancel();
  }
}