import 'dart:async';

import '../../subject.dart';

/* -= Subject =- */

mixin SinkableSubject<State> on Subject<State> implements Sink<State> {
  @override void add(State data) => notify(data);
  
  @override Future close() {
    for (final observer in observers) {
      detach(observer);
    }
    return Future.value();
  }
}
