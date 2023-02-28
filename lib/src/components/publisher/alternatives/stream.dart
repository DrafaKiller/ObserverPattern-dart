import 'dart:async';

import '../publisher.dart';
import '../subscriber.dart';

class StreamPublisher<Context> extends Publisher<Context> {
  final _controller = StreamController<Context>();

  Stream<Context> get stream => _controller.stream;

  @override
  void notify(Context context) {
    _controller.add(context);
    super.notify(context);
  }
}

class StreamSubscriber<Context> extends Stream<Context> with Subscriber<Context> {
  final _controller = StreamController<Context>();

  @override
  StreamSubscription<Context> listen(void Function(Context event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  void update(Context context) => _controller.add(context);
}