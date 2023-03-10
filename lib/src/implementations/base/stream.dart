
import 'dart:async';

import 'package:subject/src/mixins/streamable.dart';
import 'package:subject/src/observer.dart';
import 'package:subject/src/subject.dart';

/* -= Subject =- */

class StreamSubject<State> extends Stream<State> with Subject<State>, StreamableSubject<State> {
  @override 
  final bool sync;

  StreamSubject({ this.sync = true });
}

/* -= Observer =- */

class StreamObserver<State> extends Stream<State> with CoupledObserver<State>, StreamableObserver<State> {
  @override final bool sync;
  @override final bool autoDispose;


  StreamObserver({ this.sync = true, this.autoDispose = false });
}