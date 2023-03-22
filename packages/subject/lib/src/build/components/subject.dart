import 'dart:async';

import 'package:rxdart/transformers.dart';

import 'events.dart';

class ObservableSubject {
  ObservableSubject(this._controller);
  
  final StreamController<SubjectEvent> _controller;

  /* -= Event Streams =- */

  Stream<SubjectEvent> get events => _controller.stream;
  Stream<SubjectMethod> get methods => events.whereType<SubjectMethod>();
  Stream<SubjectProperty> get properties => events.whereType<SubjectProperty>();

  /* -= Event Listeners =- */

  Stream<T> on<T extends SubjectEvent>(String name, { bool before = false }) =>
    events
      .whereType<T>()
      .where((event) => event.name == name && event.before == before);
  
  Stream<SubjectMethod<T>> onMethod<T extends Function>(String name, { bool before = false }) =>
    on<SubjectMethod<T>>(name, before: before);

  Stream<SubjectProperty<T>> onProperty<T>(String name, { bool before = false }) =>
    on<SubjectProperty<T>>(name, before: before);
}

/* -= Class Wrapper =- */

mixin ObservableSubjectClass {
  ObservableSubject get subject;
}
