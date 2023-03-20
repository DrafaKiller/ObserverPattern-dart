import 'dart:async';
import 'dart:io';

extension AsyncProcess on Future<Process> {
  Future<int> get done async => (await this).exitCode;

  Future<void> get success {
    final completer = Completer<void>();
    done.then((code) => code == 0 ? completer.complete() : completer.completeError(code));
    return completer.future;
  }

  Future<void> get fail {
    final completer = Completer<void>();
    done.then((code) => code != 0 ? completer.complete() : completer.completeError(code));
    return completer.future;
  }

  /* -= Register callbacks =- */

  Future<R?> when<R>({
    FutureOr<R> Function()? done,
    FutureOr<R> Function()? success,
    FutureOr<R> Function()? fail,
  }) async => (
    await Future.wait([
      this.done.then((_) => done?.call()),
      if (success != null) this.success.then((_) => success.call()).catchError((_) {}),
      if (fail != null) this.fail.then((_) => fail.call()).catchError((_) {}),
    ])
  ).firstWhere((element) => element != null, orElse: () => null);
}
