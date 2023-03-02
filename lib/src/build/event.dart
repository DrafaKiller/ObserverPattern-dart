part of 'generator.dart';

class SubjectEvent<T extends Function, Executor extends SubjectExecutor<T>> extends Event<Executor> {
  SubjectEvent(super.type, super.callback);

  static SubjectEvent<T, SubjectMethodExecutor<T>> method<T extends Function>(
    String type, SubjectExecutor<T> callback
  ) => SubjectEvent(type, callback);

  static SubjectEvent<SubjectAccessorCallback<T>, SubjectAccessorExecutor<T>> accessor<T>(
    String type, T value, T previous
  ) => SubjectEvent(type, (callback) => callback(value, previous));
}

class SubjectListener<T extends Function, Executor extends SubjectExecutor<T>> extends EventListener<SubjectEvent<T, Executor>> {
  SubjectListener(String type, T callback) :
    super(type: type, callback: (event) => event.data(callback));

  static SubjectListener<T, SubjectMethodExecutor<T>> method<T extends Function>(String type, T callback) =>
    SubjectListener(type, callback);

  static SubjectListener<SubjectAccessorCallback<T>, SubjectAccessorExecutor<T>> accessor<T>(
    String type, SubjectAccessorCallback<T> callback
  ) => SubjectListener(type, callback);
}
