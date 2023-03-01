import 'package:observer/observer.dart';


class Subscriber<Message> extends Stream<Message> with Observer<Message>, Callable<Message>, Streamable<Message>, Cancelable<Message> {
  @override
  final SubscriberCallback<Message>? callback;
  
  Subscriber([ this.callback ]);
}

typedef SubscriberCallback<Message> = void Function(Subject<Message> subject, Message message);