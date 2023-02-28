import 'dart:async';

abstract class Subscriber<Context> {
  void update(Context context);

  /* -= Cancelable =- */

  final _completer = Completer<void>();

  Future<void> get onCancel => _completer.future;
  bool get canceled => _completer.isCompleted;

  bool cancel() {
    if (!canceled) _completer.complete();
    return canceled;
  }
}