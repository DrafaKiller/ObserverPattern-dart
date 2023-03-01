import 'dart:async';

import 'package:observer/src/observer.dart';
import 'package:observer/src/mixins/streamable.dart';

class StreamObserver<State> = Stream<State> with Observer<State>, Streamable<State>;
