part of 'generator.dart';

class SubjectObserver with CoupledObserver, Cancelable {
  final observers = <SubjectListener>[];

  /* -= Canceling =- */

  @override
  bool get isCanceled => observers.every((observer) => observer.isCanceled);

  @override
  Future<void> get onCancel => 
    isCanceled
      ? Future.value()
      : observers.firstWhere((observer) => !observer.isCanceled).onCancel;

  @override
  bool cancel() {
    bool canceled = false;
    for (final observer in observers) {
      canceled = observer.cancel() || canceled;
    }
    return canceled;
  }
}
