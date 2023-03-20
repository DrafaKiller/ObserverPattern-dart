import 'dart:async';

import 'package:subject/src/mixins/async/streamable.dart';
import 'package:subject/src/observer.dart';
import 'package:subject/src/subject.dart';

/* -= Subject =- */

class StreamSubject<State> extends Stream<State> with Subject<State>, StreamableSubject<State> {
  StreamSubject({ this.sync = true });

  @override 
  final bool sync;
}

/* -= Observer =- */

class StreamObserver<State> extends Stream<State> with CoupledObserver<State>, StreamableObserver<State> {
  StreamObserver({ this.sync = true, this.autoDispose = false });

  @override final bool sync;
  @override final bool autoDispose;
}
