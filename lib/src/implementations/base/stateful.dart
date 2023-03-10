import 'package:subject/src/subject.dart';
import 'package:subject/src/observer.dart';
import 'package:subject/src/mixins/stateful.dart';

class StatefulSubject<State> extends Subject<State> with SubjectState<State> {
  @override final bool notifyOnAttach;

  StatefulSubject({ State? state, this.notifyOnAttach = false }) {
    if (state != null) this.state = state;
  }
}

class StatefulObserver<State> with Observer<State>, ObserverState<State> {}