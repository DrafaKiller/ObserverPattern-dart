import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:subject/src/build/annotations.dart';

class SubjectGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final output = StringBuffer();

    for (final annotated in library.annotatedWith(TypeChecker.fromRuntime(String))) {
      if (annotated.annotation.stringValue != subject) continue;

      final element = annotated.element;

      output.writeln(
        Extension((_) => _
          ..name = '${element.name}Subject'
          ..
        ).accept(DartEmitter()).toString(),
      );
    }

    return output.toString();
  }
}