/* -= Listener Callbacks =- */

import 'event.dart';

typedef EventDispatchCallback<T extends Event> = void Function(T event);
typedef EventCallback<T> = void Function(T data);