import 'package:subject/src/subject.dart';

typedef SubscriberCallback<Message> = void Function(Subject<Message> subject, Message message);
