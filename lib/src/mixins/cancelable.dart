import 'dart:async';

import 'package:subject/observer.dart';

mixin Cancelable<State> on CoupledObserver<State> {
  final _completer = Completer<void>.sync();

  /// A future that completes when the observer is canceled.
  Future<void> get onCancel => _completer.future;

  /// Whether the observer is canceled.
  bool get isCanceled => _completer.isCompleted;

  /// Cancels the observer.
  /// 
  /// Returns `true` if the observer was canceled, `false` otherwise.
  /// 
  /// If the observer is canceled, it is detached from the subject.
  /// 
  /// It may also execute other actions that that follow `onCancel`.
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