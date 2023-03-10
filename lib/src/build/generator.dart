import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:subject/src/utils/analyzer.dart';
import 'package:subject/src/utils/code_analyzer.dart';
import 'package:subject/src/utils/string.dart';
import 'package:subject/subject.dart';
import 'package:source_gen/source_gen.dart';

part 'event.dart';
part 'observer.dart';

class SubjectGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final output = StringBuffer();
    
    for (final element in library.allElements) {
      if (element is! ClassElement) continue;
      
      final methods = element.methods.where((method) => method.hasStringAnnotation(observe));
      final accessors = element.accessors.where((accessor) => accessor.variable.hasStringAnnotation(observe));

      if (methods.isNotEmpty || accessors.isNotEmpty) {
        output.writeln(createSubject(element, methods: methods, accessors: accessors));
        continue;
      }
      
      if (element.hasStringAnnotation(subject)) {
        output.writeln(createSubject(element, methods: element.methods, accessors: element.accessors));
        continue;
      }
    }

    return output.toString();
  }

  static String createSubject(ClassElement element, { Iterable<MethodElement> methods = const [], Iterable<PropertyAccessorElement> accessors = const [] }) {
    accessors = accessors.where((accessor) => accessor.isSetter);

    final output = StringBuffer();

    output.writeln('class ${element.name}Subject${element.toCodeTypes()} = ${element.toCodeType().toSource()} with Observable${element.name};');

    output.writeAll([
      for (final method in methods)
        '''
          typedef ${ getMethodFunctionName(element, method) } =
            ${ method.toCodeType().rebuild((_) => _..returnType = refer('void')).toSource() };
        ''',

      for (final accessor in accessors)
        '''
          typedef ${ getAccessorFunctionName(element, accessor) } =
            ${ accessor.variable.type.toCode().toSource() };
        '''
    ]);

    output.writeln(
      Mixin((_) => _
        ..name = 'Observable${element.name}'
        ..types.addAll(element.typeParameters.map((type) => type.toCode()))
        ..on = element.toCodeType()

        ..fields.add(
          Field((_) => _
            ..name = '_emitter'
            ..assignment = Code('EventEmitter()')
            ..modifier = FieldModifier.final$
          ),
        )

        ..methods.addAll([
          Method((_) {_
            ..name = 'on'
            ..returns = refer('SubjectObserver')
            ..optionalParameters.addAll([
              for (final method in methods)
                ...[
                  Parameter((_) => _
                    ..name = method.name
                    ..type = refer('${ getMethodFunctionName(element, method, short: true) }?')
                    ..named = true
                  ),
                ],

              for (final accessor in accessors)
                ...[
                  Parameter((_) => _
                    ..name = accessor.displayName
                    ..type = refer('SubjectAccessorCallback<${ getAccessorFunctionName(element, accessor, short: true) }>?')
                    ..named = true
                  ),
                ],
            ])
            ..body = Code('''
              return SubjectObserver()..observers.addAll([
                ${
                  [
                    ...methods.map((method) => '''
                      if (${ method.displayName } != null) SubjectListener.method('${ method.displayName }::after', ${ method.displayName }).addTo(_emitter),
                    '''),
                    ... accessors.map((accessor) => '''
                      if (${ accessor.displayName } != null) SubjectListener.accessor('${ accessor.displayName }::after', ${ accessor.displayName }).addTo(_emitter),
                    '''),
                  ].join()
                }
              ]);
            ''');
          }),
          
          Method((_) {_
            ..name = 'onBefore'
            ..returns = refer('SubjectObserver')
            ..optionalParameters.addAll([
              for (final method in methods)
                ...[
                  Parameter((_) => _
                    ..name = method.name
                    ..type = refer('${ getMethodFunctionName(element, method, short: true) }?')
                    ..named = true
                  ),
                ],

              for (final accessor in accessors)
                ...[
                  Parameter((_) => _
                    ..name = accessor.displayName
                    ..type = refer('SubjectAccessorCallback<${ getAccessorFunctionName(element, accessor, short: true) }>?')
                    ..named = true
                  ),
                ],
            ])
            ..body = Code('''
              return SubjectObserver()..observers.addAll([
                ${
                  [
                    ...methods.map((method) => '''
                      if (${ method.displayName } != null) SubjectListener.method('${ method.displayName }::before', ${ method.displayName }).addTo(_emitter),
                    '''),
                    ... accessors.map((accessor) => '''
                      if (${ accessor.displayName } != null) SubjectListener.accessor('${ accessor.displayName }::before', ${ accessor.displayName }).addTo(_emitter),
                    '''),
                  ].join()
                }
              ]);
            ''');
          })
        ])

        /* -= Generating =- */

        ..methods.addAll([
          for (final method in methods)
            method.toCode().rebuild((_) => _
              ..annotations.add(refer('override'))
              ..body = Code('''
                _emitter.dispatch(SubjectEvent.method<${ getMethodFunctionName(element, method) }>('${method.name}::before', (callback) => ${ method.toCodeInvoke(target: refer('callback')).toSource() }));
                final result = super.${method.name}${ method.toCodeInvoke().toSource() };
                _emitter.dispatch(SubjectEvent.method<${ getMethodFunctionName(element, method) }>('${method.name}::after', (callback) => ${ method.toCodeInvoke(target: refer('callback')).toSource() }));
                return result;
              ''')
            ),
          
          for (final accessor in accessors)
            accessor.toCode().rebuild((_) => _
              ..returns = null
              ..annotations.add(refer('override'))
              ..requiredParameters.clear()
              ..requiredParameters.add(
                Parameter((_) => _
                  ..name = 'value'
                  ..type = accessor.variable.type.toCode()
                )
              )

              ..body = Code('''
                final previous = super.${accessor.displayName};
                _emitter.dispatch(SubjectEvent.accessor('${accessor.displayName}::before', value, previous));
                super.${accessor.displayName} = value;
                _emitter.dispatch(SubjectEvent.accessor('${accessor.displayName}::after', value, previous));
              ''')
            ),
        ])
      ).toSource(),
    );

    return output.toString();
  }

  static String getMethodFunctionName(ClassElement element, MethodElement method, { bool short = false }) =>
    '${ element.displayName }Subject${ method.displayName.toPascalCase() }Method${ element.toCodeTypes(short: short) }';

  static String getAccessorFunctionName(ClassElement element, PropertyAccessorElement accessor, { bool short = false }) =>
    '${ element.displayName }Subject${ accessor.displayName.toPascalCase() }Accessor${ element.toCodeTypes(short: short) }';
}

/* -= Definitions =- */

typedef SubjectAccessorCallback<T> = void Function(T value, T previous);

typedef SubjectExecutor<T extends Function> = void Function(T callback);
typedef SubjectMethodExecutor<T extends Function> = SubjectExecutor<T>;
typedef SubjectAccessorExecutor<T> = SubjectExecutor<SubjectAccessorCallback<T>>;
