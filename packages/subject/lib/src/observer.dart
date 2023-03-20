import 'dart:collection';

import 'package:subject/src/mixins/callbackable.dart';

import 'implementations/base/callback.dart';
import 'implementations/base/stateful.dart';
import 'implementations/base/stream.dart';
import 'subject.dart';

/* -= Uncoupled Observer =- */

/// ## Observer Pattern - `Observer`
/// 
/// The `Observer` class is an abstract class that defines the behavior of an observer in the Observer Pattern.
/// An observer is an object that watches a subject and receives updates when the subject's state changes.
/// 
/// The observer can be attached to or detached from a `Subject`.
/// 
/// When there's a change in the state of the subject, the observer is notified through a function called update. This function can then perform some actions with the new state information provided to it by the subject.
/// 
/// ### Alternative Constructors
/// 
/// It's provided alternative constructors to create an observer.
/// - `coupled` - Creates a **CallbackCoupledObserver** that is notified when is attached or detached from a subject
/// - `stream` - Creates a **StreamObserver** that can be listened to
/// - `stateful` - Creates a **StatefulObserver** that holds the last state of the subject
abstract class Observer<State> {
  /* -= Alternative Implementations =- */

  factory Observer(ObserverCallback<State> callback) = CallbackObserver<State>;
  
  factory Observer.coupled({
    CoupledObserverCallback<State>? attached,
    CoupledObserverCallback<State>? detached,
  }) = CallbackCoupledObserver<State>;

  static StreamObserver<State> stream<State>({ bool sync = true, bool autoDispose = false }) =>
    StreamObserver<State>(sync: sync, autoDispose: autoDispose);

  static StatefulObserver<State> stateful<State>() => StatefulObserver<State>();

  /* -= Methods =- */

  /// This method is called whenever there is a change in the state of the `Subject`.
  /// - `subject` - A reference to the subject object that triggered the update.
  /// - `state` - The new state information provided by the subject.
  /// 
  /// Implementations of the `Observer` class should provide an implementation of the `update()` method to perform actions with the new state information provided.
  void update(Subject<State> subject, State state) {}
}

/* -= Coupled Observer =- */

abstract class CoupledObserver<State> implements Observer<State> {
  final _subjects = <Subject<State>>[];

  /// List of subjects that the observer is attached to.
  /// This list is `unmodifiable`.
  List<Subject<State>> get subjects => UnmodifiableListView(_subjects);
  
  @override
  void update(Subject<State> subject, State state) {}

  /// This method is called whenever the observer is attached to a subject.
  /// - `subject` - A reference to the subject object that triggered the update.
  void attached(Subject<State> subject) => _subjects.add(subject);

  /// This method is called whenever the observer is detached from a subject.
  /// - `subject` - A reference to the subject object that triggered the update.
  void detached(Subject<State> subject) => _subjects.remove(subject);
}
