import 'dart:async';

abstract class SubjectEvent {
  const SubjectEvent(this.name, { this.before = false });

  final String name;
  final bool before;
  abstract final Function execute;

  /* -= Constructors =- */

  static SubjectMethod<T> method<T extends Function>(String name, MethodExecute<T> execute, { bool before = false }) =>
    SubjectMethod(name, execute, before: before);

  static SubjectProperty<T> property<T>(String name, T value, T previous, { bool before = false }) =>
    SubjectProperty(name, value, previous, before: before);
}

/* -= Event Execution Definitions =- */

typedef Executor<T extends Function> = void Function(T callback);
typedef PropertyCallback<T> = void Function(T value, T previous);

typedef MethodExecute<T extends Function> = Executor<T>;
typedef PropertyExecute<T> = Executor<PropertyCallback<T>>;

/* -= Subject Events =- */

class SubjectMethod<T extends Function> extends SubjectEvent {
  const SubjectMethod(super.name, this.execute, { super.before = false });

  @override
  final MethodExecute<T> execute;
}

class SubjectProperty<T> extends SubjectEvent {
  const SubjectProperty(super.name, this.value, this.previous, { super.before = false });

  final T value;
  final T previous;

  @override
  PropertyExecute<T> get execute => (callback) => callback(value, previous);
}

/* -= Event Execution =- */

class SubjectExecute<T extends Function, EventT extends SubjectEvent> {
  SubjectExecute(this.stream, this.callback);

  final Stream<EventT> stream;
  final T callback;

  late final StreamSubscription<EventT> subscription = stream.listen(
    (event) => (event.execute as Executor<T>).call(callback),
  );
  
  Future<void> cancel() => subscription.cancel();
}
