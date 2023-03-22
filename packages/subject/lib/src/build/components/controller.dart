import 'dart:async';

import 'events.dart';
import 'subject.dart';

class ObservableSubjectController {
  ObservableSubjectController({ bool sync = true }) :
    _controller = StreamController<SubjectEvent>.broadcast(sync: sync);

  final StreamController<SubjectEvent> _controller;
  late final ObservableSubject subject = ObservableSubject(_controller);

  /* -= Event Emitters =- */

  void dispatch(SubjectEvent event) => _controller.add(event);

  void method<T extends Function>(String name, MethodExecute<T> executor, { bool before = false }) =>
    dispatch(SubjectEvent.method(name, executor, before: before));

  void property<T>(String name, T value, T previous, { bool before = false }) =>
    dispatch(SubjectEvent.property(name, value, previous, before: before));
    
  /* -= Event Executors =- */

  SubjectExecute<T, SubjectMethod<T>> onMethod<T extends Function>(
    String name,
    T callback, {
    bool before = false,
  }) => SubjectExecute(subject.onMethod<T>(name, before: before), callback);

  SubjectExecute<PropertyCallback<T>, SubjectProperty<T>> onProperty<T>(
    String name,
    PropertyCallback<T> callback, {
    bool before = false,
  }) => SubjectExecute(subject.onProperty<T>(name, before: before), callback);
}
