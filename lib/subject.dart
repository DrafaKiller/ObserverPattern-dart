library subject;

export 'src/build/annotations.dart';
export 'src/build/generator.dart' show SubjectExecutor, SubjectAccessorCallback, SubjectObserver, SubjectEvent, SubjectListener;

/* -= Builder dependencies =- */

export 'package:subject/observer.dart';
export 'package:subject/event_emitter.dart';
