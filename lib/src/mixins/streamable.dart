import 'dart:async';

import '../observer.dart';
import '../subject.dart';

mixin Streamable<State> on Observer<State> implements Stream<State> {
  bool get sync => true;
  late final _controller = StreamController<State>.broadcast(sync: sync);

  /* -= Observer =- */

  @override
  void update(Subject<State> subject, State state) {
    super.update(subject, state);
    _controller.add(state);
  }

  /* -= Stream =- */

  @override
  StreamSubscription<State> listen(
    void Function(State event)? onData,
    {
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError
    }
  ) => _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
