class Event<T> {
  Event(this.type, this.data);

  final String type;
  final T data;

  Event<Event<T>> get nested => Event<Event<T>>(type, this);

  /* -= Cancelable =- */

  bool _isCanceled = false;
  bool get isCanceled => _isCanceled;
  void cancel() => _isCanceled = true;

  /* -= Resolvable =- */

  bool _isResolved = false;
  bool get isResolved => _isResolved;
  void resolve() => _isResolved = true;
}
