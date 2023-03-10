import 'package:subject/src/mixins/async/sinkable.dart';
import 'package:subject/src/subject.dart';

/* -= Subject =- */

class SinkSubject<State> = Subject<State> with SinkableSubject<State>;