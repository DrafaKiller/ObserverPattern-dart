library subject;

export 'src/build/annotations.dart';
export 'src/build/generator.dart' show SubjectExecutor, SubjectAccessorCallback, SubjectObserver, SubjectEvent, SubjectListener;

/* -= Builder dependencies =- */

export 'package:observer/observer.dart';
export 'package:observer/event_emitter.dart';
