import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:subject/subject.dart';
import 'package:subject_gen/src/utils/analyzer.dart';

SubjectWith? subjectOptionsOf(ClassElement element) {
  final annotations = element.getAnnotations(const TypeChecker.fromRuntime(SubjectWith));
  if (annotations.isEmpty) return null;

  final annotation = annotations.first;
  return SubjectWith(
    name: annotation.getField('name')?.toStringValue(),
    observable: annotation.getField('observable')?.toBoolValue() ?? true,
    observableName: annotation.getField('observableName')?.toStringValue(),
  ); 
}
