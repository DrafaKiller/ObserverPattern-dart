import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'events.dart';

class SubjectSubscription extends Stream<SubjectEvent> {
  SubjectSubscription(List<Stream<SubjectEvent>> streams, [ this._subscriptions = const [] ]) : _stream = Rx.merge(streams);

  factory SubjectSubscription.fromExecutions(List<SubjectExecute> executions) {
    final streams = <Stream<SubjectEvent>>[];
    final subscriptions = <StreamSubscription<SubjectEvent>>[];

    for (final execution in executions) {
      streams.add(execution.stream);
      subscriptions.add(execution.subscription);
    }

    return SubjectSubscription(streams, subscriptions);
  }
  
  final List<StreamSubscription<SubjectEvent>> _subscriptions;
  final Stream<SubjectEvent> _stream;

  /* -= Stream =- */
  
  @override
  StreamSubscription<SubjectEvent> listen(
    void Function(SubjectEvent event)? onData,
    {
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError,
    }
  ) => _stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  /* -= Cancelable =- */

  final _completer = Completer<void>.sync();

  Future<void> get onCancel => _completer.future;
  bool get isCanceled => _completer.isCompleted;

  bool cancel() {
    final wasCanceled = isCanceled;
    if (!isCanceled) {
      for (final subscription in _subscriptions) {
        subscription.cancel();
      }
      _completer.complete();
    }
    return wasCanceled != isCanceled;
  }
}
