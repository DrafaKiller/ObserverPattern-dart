import 'package:subject/src/mixins/stateful.dart';
import 'package:subject/src/observer.dart';
import 'package:subject/src/subject.dart';

class StatefulSubject<State> extends Subject<State> with SubjectState<State> {
  StatefulSubject({ State? state, this.notifyOnAttach = false }) {
    if (state != null) this.state = state;
  }

  @override final bool notifyOnAttach;
}

class StatefulObserver<State> with Observer<State>, ObserverState<State> {}
