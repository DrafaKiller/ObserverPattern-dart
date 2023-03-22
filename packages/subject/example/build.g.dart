// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build.dart';

// **************************************************************************
// SubjectGenerator
// **************************************************************************

typedef UserSubjectSayMethod<T> = void Function(String message);

typedef UserSubjectThoughtAccessor<T> = String?;

class UserSubject<T> = User<T> with ObservableUser<T>, _UserSubject<T>;
mixin _UserSubject<T> on ObservableUser<T>, User<T> {
  @override
  void say(String message) {
    _controller.method(
        'say', (UserSubjectSayMethod<T> callback) => callback(message),
        before: true);
    final result = super.say(message);
    _controller.method(
        'say', (UserSubjectSayMethod<T> callback) => callback(message));
    return result;
  }

  @override
  set thought(String? value) {
    final previous = super.thought;
    _controller.property('thought', value, previous, before: true);
    super.thought = value;
    _controller.property('thought', value, previous);
  }
}

mixin ObservableUser<T> implements ObservableSubjectClass {
  final _controller = ObservableSubjectController();

  @override
  ObservableSubject get subject {
    return _controller.subject;
  }

  SubjectSubscription on({
    UserSubjectSayMethod<T>? say,
    PropertyCallback<UserSubjectThoughtAccessor<T>>? thought,
  }) {
    return SubjectSubscription.fromExecutions([
      if (say != null)
        _controller.onMethod<void Function(String message)>('say', say),
      if (thought != null) _controller.onProperty('thought', thought),
    ]);
  }

  SubjectSubscription onBefore({
    UserSubjectSayMethod<T>? say,
    PropertyCallback<UserSubjectThoughtAccessor<T>>? thought,
  }) {
    return SubjectSubscription.fromExecutions([
      if (say != null)
        _controller.onMethod<void Function(String message)>('say', say,
            before: true),
      if (thought != null)
        _controller.onProperty('thought', thought, before: true),
    ]);
  }
}
