import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

/* -= Annotations =- */

extension ElementHasAnnotation on Element {
  /* -= Accessing =- */

  List<DartObject> getAnnotations(TypeChecker checker) =>
    checker.annotationsOf(this).toList();

  Set<String> getStringAnnotations() =>
    getAnnotations(TypeChecker.fromRuntime(String))
      .map((annotation) => annotation.toStringValue()!)
      .toSet();

  /* -= Checking =- */
  
  bool hasAnnotation(TypeChecker checker) =>
    getAnnotations(checker).isNotEmpty;

  bool hasStringAnnotation(String name) =>
    getStringAnnotations().contains(name);
}
