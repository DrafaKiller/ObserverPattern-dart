import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:subject/subject.dart';
import 'package:subject_gen/src/build/annotations.dart';
import 'package:subject_gen/src/build/subject_class.dart';

import '../utils/analyzer.dart';

class SubjectGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final output = StringBuffer();
    
    for (final element in library.allElements) {
      if (element is! ClassElement) continue;

      final options = subjectOptionsOf(element);
      
      final observeMethods = element.methods.where(
        (method) =>
          method.hasStringAnnotation(observe) &&
          !method.hasStringAnnotation(dontObserve),
      );
      
      final observeAccessors = element.accessors.where(
        (accessor) =>
          accessor.variable.hasStringAnnotation(observe) &&
          !accessor.variable.hasStringAnnotation(dontObserve),
      );

      if (observeMethods.isNotEmpty || observeAccessors.isNotEmpty) {
        output.writeln(
          SubjectClass.options(
            element,
            methods: observeMethods,
            accessors: observeAccessors,
            options: options
          ).toSource(),
        );
        continue;
      }
      
      if (element.hasStringAnnotation(subject) || options != null) {
        output.writeln(
          SubjectClass.options(
            element,
            methods: element.methods.where((method) => !method.hasStringAnnotation(dontObserve)),
            accessors: element.accessors.where((accessor) => !accessor.variable.hasStringAnnotation(dontObserve)),
            options: options
          ).toSource(),
        );
        continue;
      }
    }

    return output.toString();
  }
}
