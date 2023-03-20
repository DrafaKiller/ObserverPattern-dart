import 'dart:async';

import 'events.dart';

class ObservableSubject {
  const ObservableSubject(this._controller);
  
  final StreamController<SubjectEvent> _controller;

  /* -= Event Streams =- */

  Stream<SubjectEvent> get events => _controller.stream;
  Stream<SubjectMethod> get methods => events.where((event) => event is SubjectMethod).cast<SubjectMethod>();
  Stream<SubjectProperty> get properties => events.where((event) => event is SubjectProperty).cast<SubjectProperty>();

  /* -= Event Listeners =- */
  
  Stream<SubjectMethod<T>> onMethod<T extends Function>(String name, { bool before = false }) =>
    methods
      .where((event) => event is SubjectMethod<T> && event.name == name && event.before == before)
      .cast<SubjectMethod<T>>();

  Stream<SubjectProperty<T>> onProperty<T>(String name, { bool before = false }) =>
    properties
      .where((event) => event is SubjectProperty<T> && event.name == name && event.before == before)
      .cast<SubjectProperty<T>>();
}
