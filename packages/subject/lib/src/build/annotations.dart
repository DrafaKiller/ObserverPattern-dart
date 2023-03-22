const subject = 'subject';
const observe = 'observe';
const dontObserve = 'dontObserve';

class SubjectWith {
  const SubjectWith({
    this.name,
    this.observableName,
    this.observable = true,
    this.sync = true,
  });

  final String? name;
  final String? observableName;
  final bool observable;
  final bool sync;
}
