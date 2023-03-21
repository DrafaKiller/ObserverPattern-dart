const subject = 'subject';
const observe = 'observe';
const dontObserve = 'dontObserve';

class SubjectWith {
  const SubjectWith({
    this.name,
    this.observable = true,
    this.observableName,
  });

  final String? name;
  final bool observable;
  final String? observableName;
}
