import 'package:subject/src/observer.dart';
import 'package:subject/src/subject.dart';
import 'package:subject/src/mixins/callbackable.dart';

/* -= Uncoupled Observer =- */

class CallbackObserver<State> with Observer<State>, Callbackable<State> {
  @override 
  final ObserverCallback<State>? callback;

  CallbackObserver([ this.callback ]);
}

/* -= Coupled Observer =- */

class CallbackCoupledObserver<State> with CoupledObserver<State>, Callbackable<State> {
  @override
  final ObserverCallback<State>? callback;

  final CoupledObserverCallback<State>? _attached;
  final CoupledObserverCallback<State>? _detached;

  CallbackCoupledObserver({
    this.callback,
    CoupledObserverCallback<State>? attached,
    CoupledObserverCallback<State>? detached
  }) :
    _attached = attached,
    _detached = detached;

  @override
  void attached(Subject<State> subject) {
    super.attached(subject);
    _attached?.call(subject, this);
  }

  @override
  void detached(Subject<State> subject) {
    super.detached(subject);
    _detached?.call(subject, this);
  }
}

/* -= Definitions =- */

typedef CoupledObserverCallback<State> = void Function(Subject<State> subject, CallbackCoupledObserver<State> observer);