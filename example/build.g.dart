// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build.dart';

// **************************************************************************
// SubjectGenerator
// **************************************************************************

class UserSubject<T> = User<T> with ObservableUser;
typedef UserSubjectSayMethod<T> = void Function(String message);
typedef UserSubjectThoughtAccessor<T> = String?;
mixin ObservableUser<T> on User<T> {
  final _emitter = EventEmitter();

  SubjectObserver on({
    UserSubjectSayMethod<T>? say,
    SubjectAccessorCallback<UserSubjectThoughtAccessor<T>>? thought,
  }) {
    return SubjectObserver()
      ..observers.addAll([
        if (say != null)
          SubjectListener.method('say::after', say).addTo(_emitter),
        if (thought != null)
          SubjectListener.accessor('thought::after', thought).addTo(_emitter),
      ]);
  }

  SubjectObserver onBefore({
    UserSubjectSayMethod<T>? say,
    SubjectAccessorCallback<UserSubjectThoughtAccessor<T>>? thought,
  }) {
    return SubjectObserver()
      ..observers.addAll([
        if (say != null)
          SubjectListener.method('say::before', say).addTo(_emitter),
        if (thought != null)
          SubjectListener.accessor('thought::before', thought).addTo(_emitter),
      ]);
  }

  @override
  void say(String message) {
    _emitter.dispatch(SubjectEvent.method<UserSubjectSayMethod<T>>(
        'say::before', (callback) => callback(message)));
    final result = super.say(message);
    _emitter.dispatch(SubjectEvent.method<UserSubjectSayMethod<T>>(
        'say::after', (callback) => callback(message)));
    return result;
  }

  @override
  set thought(String? value) {
    final previous = super.thought;
    _emitter
        .dispatch(SubjectEvent.accessor('thought::before', value, previous));
    super.thought = value;
    _emitter.dispatch(SubjectEvent.accessor('thought::after', value, previous));
  }
}
