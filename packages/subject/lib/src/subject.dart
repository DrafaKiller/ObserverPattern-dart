import 'dart:collection';

import 'package:subject/observer.dart';

import 'implementations/base/sink.dart';

/// ## Observer Pattern - `Subject`
/// 
/// The `Subject` class is an abstract class that defines the behavior of a subject in the Observer Pattern.
/// 
/// A subject is an object that maintains a list of observers and notifies them when its state changes.
/// 
/// The subject can attach or detach observers to itself.
/// 
/// When there's a change in the state of the subject, the subject notifies all of its observers through a function called update.
/// This function can then perform some actions with the new state information provided to it by the subject.
/// 
/// ### Alternative Constructors
/// 
/// It's provided alternative constructors to create a subject.
/// - `stream` - Creates a **StreamSubject** that can be listened to, like a stream
/// - `sink` - Creates a **SinkSubject** that can add new states, like a sink
/// - `stateful` - Creates a **StatefulSubject** that holds the current state of the subject
class Subject<State> {
  final _observers = <Observer<State>>[];

  /// List of observers that are attached to the subject. This list is `unmodifiable`.
  List<Observer<State>> get observers => UnmodifiableListView(_observers);

  /* -= Alternative Implementations =- */
  
  static StreamSubject<State> stream<State>({ bool sync = true }) => StreamSubject<State>(sync: sync);

  static SinkSubject<State> sink<State>() => SinkSubject<State>();

  static StatefulSubject<State> stateful<State>({ State? state, bool notifyOnAttach = false }) =>
    StatefulSubject<State>(state: state, notifyOnAttach: notifyOnAttach);

  /* -= Methods =- */
  
  /// Attaches an observer to the subject.
  /// - `observer` - The observer to attach to the subject.
  /// 
  /// When an observer is attached to a subject, it is added to the list of observers to be notified when there's a change in the state of the subject.
  /// 
  /// If the observer is a `CoupledObserver`, it is notified that it was attached to the subject.
  void attach(Observer<State> observer) {
    _observers.add(observer);
    if (observer is CoupledObserver<State>) observer.attached(this);
  }

  /// Detaches an observer from the subject.
  /// - `observer` - The observer to detach from the subject.
  /// 
  /// Detached observers are no longer notified when there's a change in the state of the subject.
  /// 
  /// If the observer is a `CoupledObserver`, it is notified that it was detached from the subject.
  void detach(Observer<State> observer) {
    _observers.remove(observer);
    if (observer is CoupledObserver<State>) observer.detached(this);
  }

  /// Notifies all observers that there's a change in the state of the subject.
  /// - `state` - The new state information provided by the subject.
  /// 
  /// This method will call the `update()` method of all observers attached to the subject.
  void notify(State state) {
    for (final observer in observers) {
      observer.update(this, state);
    }
  }
}
