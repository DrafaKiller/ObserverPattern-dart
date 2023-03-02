import 'package:observer/observer.dart';

import 'callbacks.dart';

class Subscriber<Message> extends Stream<Message> with CoupledObserver<Message>, Callable<Message>, StreamableObserver<Message>, Cancelable<Message> {
  @override
  final SubscriberCallback<Message>? callback;
  
  Subscriber([ this.callback ]);
}
