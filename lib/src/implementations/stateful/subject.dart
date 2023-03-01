import 'package:observer/src/subject.dart';
import 'package:observer/src/mixins/stateful.dart';

class StatefulSubject<State> extends Subject<State> with SubjectState<State> {
  @override final bool notifyOnAttach;

  StatefulSubject({ State? state, this.notifyOnAttach = false }) {
    if (state != null) this.state = state;
  }
}