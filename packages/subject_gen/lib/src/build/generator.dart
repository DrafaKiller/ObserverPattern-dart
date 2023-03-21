import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import './annotations.dart';
import '../utils/analyzer.dart';
import '../utils/code_analyzer.dart';
import '../utils/string.dart';

class SubjectGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final output = StringBuffer();
    
    for (final element in library.allElements) {
      if (element is! ClassElement) continue;
      
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
        output.writeln(createSubject(element, methods: observeMethods, accessors: observeAccessors));
        continue;
      }
      
      if (element.hasStringAnnotation(subject)) {
        output.writeln(
          createSubject(
            element,
            methods: element.methods.where((method) => !method.hasStringAnnotation(dontObserve)),
            accessors: element.accessors.where((accessor) => !accessor.variable.hasStringAnnotation(dontObserve)),
          ),
        );
        continue;
      }
    }

    return output.toString();
  }

  static String createSubject(ClassElement element, { Iterable<MethodElement> methods = const [], Iterable<PropertyAccessorElement> accessors = const [] }) {
    methods = methods.where((method) => method.isPublic && !method.isOperator && !method.isStatic && !method.isAbstract);
    accessors = accessors.where((accessor) => accessor.isSetter);

    final output = StringBuffer();

    output.writeln('${ element.isAbstract ? 'abstract ' : '' }class ${element.name}Subject${element.toCodeTypes()} = ${element.toCodeType().toSource()} with Observable${element.name};');

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
            ..name = '_controller'
            ..assignment = const Code('ObservableSubjectController()')
            ..modifier = FieldModifier.final$,
          ),
        )

        ..methods.addAll([
          Method((_) => _
            ..name = 'observable'
            ..type = MethodType.getter
            ..returns = refer('ObservableSubject')
            ..body = const Code('return _controller.subject;'),
          ),

          Method((_) {_
            ..name = 'on'
            ..returns = refer('SubjectSubscription')
            ..optionalParameters.addAll([
              for (final method in methods)
                ...[
                  Parameter((_) => _
                    ..name = method.name
                    ..type = refer('${ getMethodFunctionName(element, method, short: true) }?')
                    ..named = true,
                  ),
                ],

              for (final accessor in accessors)
                ...[
                  Parameter((_) => _
                    ..name = accessor.displayName
                    ..type = refer('PropertyCallback<${ getAccessorFunctionName(element, accessor, short: true) }>?')
                    ..named = true,
                  ),
                ],
            ])
            ..body = Code('''
              return SubjectSubscription.fromExecutions([
                ${
                  [
                    ...methods.map((method) => '''
                      if (${ method.displayName } != null) _controller.onMethod<${ method.toCodeType().toSource() }>('${ method.displayName }', ${ method.displayName }),
                    ''',),
                    ... accessors.map((accessor) => '''
                      if (${ accessor.displayName } != null) _controller.onProperty('${ accessor.displayName }', ${ accessor.displayName }),
                    ''',),
                  ].join()
                }
              ]);
            ''');
          }),
          
          Method((_) {_
            ..name = 'onBefore'
            ..returns = refer('SubjectSubscription')
            ..optionalParameters.addAll([
              for (final method in methods)
                ...[
                  Parameter((_) => _
                    ..name = method.name
                    ..type = refer('${ getMethodFunctionName(element, method, short: true) }?')
                    ..named = true,
                  ),
                ],

              for (final accessor in accessors)
                ...[
                  Parameter((_) => _
                    ..name = accessor.displayName
                    ..type = refer('PropertyCallback<${ getAccessorFunctionName(element, accessor, short: true) }>?')
                    ..named = true,
                  ),
                ],
            ])
            ..body = Code('''
              return SubjectSubscription.fromExecutions([
                ${
                  [
                    ...methods.map((method) => '''
                      if (${ method.displayName } != null) _controller.onMethod<${ method.toCodeType().toSource() }>('${ method.displayName }', ${ method.displayName }, before: true),
                    ''',),
                    ... accessors.map((accessor) => '''
                      if (${ accessor.displayName } != null) _controller.onProperty('${ accessor.displayName }', ${ accessor.displayName }, before: true),
                    ''',),
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
                _controller.method('${method.displayName}', (${ getMethodFunctionName(element, method) } callback) => ${ method.toCodeInvoke(target: refer('callback')).toSource() }, before: true);
                final result = super.${method.name}${ method.toCodeInvoke().toSource() };
                _controller.method('${method.displayName}', (${ getMethodFunctionName(element, method) } callback) => ${ method.toCodeInvoke(target: refer('callback')).toSource() });
                return result;
              '''),
            ),
          
          for (final accessor in accessors)
            accessor.toCode().rebuild((_) => _
              ..returns = null
              ..annotations.add(refer('override'))
              ..requiredParameters.clear()
              ..requiredParameters.add(
                Parameter((_) => _
                  ..name = 'value'
                  ..type = accessor.variable.type.toCode(),
                ),
              )

              ..body = Code('''
                final previous = super.${accessor.displayName};
                _controller.property('${accessor.displayName}', value, previous, before: true);
                super.${accessor.displayName} = value;
                _controller.property('${accessor.displayName}', value, previous);
              '''),
            ),
        ]),
      ).toSource(),
    );

    return output.toString();
  }

  static String getMethodFunctionName(ClassElement element, MethodElement method, { bool short = false }) =>
    '${ element.displayName }Subject${ method.displayName.toPascalCase() }Method${ element.toCodeTypes(short: short) }';

  static String getAccessorFunctionName(ClassElement element, PropertyAccessorElement accessor, { bool short = false }) =>
    '${ element.displayName }Subject${ accessor.displayName.toPascalCase() }Accessor${ element.toCodeTypes(short: short) }';
}
