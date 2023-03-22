import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:subject/subject.dart';
import 'package:subject_gen/src/utils/code_analyzer.dart';
import 'package:subject_gen/src/utils/string.dart';

class SubjectClass {
  SubjectClass(
    this.element,  
    {
      Iterable<MethodElement>? methods,
      Iterable<PropertyAccessorElement>? accessors,

      String? subjectName,
      String? observableName,
      bool observable = true,
      this.sync = true,
    }
  ) :
    subjectName = subjectName ?? '${element.name}Subject',
    observableName = [
      if (!observable) '_',
      (observableName ?? 'Observable${element.name}'),
    ].join(),
    methods = (methods ?? [])
      .where((method) => method.isPublic && !method.isOperator && !method.isStatic && !method.isAbstract)
      .toList(),
    accessors = (accessors ?? [])
      .where((accessor) => accessor.isSetter)
      .toList();

  factory SubjectClass.options(
    ClassElement element,
    {
      Iterable<MethodElement>? methods,
      Iterable<PropertyAccessorElement>? accessors,
      SubjectWith? options,
    }
  ) =>
    SubjectClass(
      element,
      methods: methods,
      accessors: accessors,
      
      subjectName: options?.name,
      observableName: options?.observableName,
      observable: options?.observable ?? true,
      sync: options?.sync ?? true,
    );

  /* -= Properties =- */

  final ClassElement element;
  final List<MethodElement> methods;
  final List<PropertyAccessorElement> accessors;

  final String subjectName;
  final String observableName;

  final bool sync;

  /* -= Typedefs =- */

  String get methodTypes => [
    for (final method in methods)
      '''
        typedef ${ getMethodFunctionName(method) } =
          ${ method.toCodeType().rebuild((_) => _..returnType = refer('void')).toSource() };
      ''',
  ].join('\n');

  String get accessorTypes => [
    for (final accessor in accessors)
      '''
        typedef ${ getAccessorFunctionName(accessor) } =
          ${ accessor.variable.type.toCode().toSource() };
      ''',
  ].join('\n');

  /* -= Methods Builders =- */

  Method createOn({ bool before = false }) =>
    Method((_) { _
      ..name = [ 'on', if (before) 'Before' ].join()
      ..returns = refer('SubjectSubscription')
      ..optionalParameters.addAll([
        for (final method in methods)
          Parameter((_) => _
            ..name = method.name
            ..type = refer('${ getMethodFunctionName(method, short: true) }?')
            ..named = true,
          ),

        for (final accessor in accessors)
          Parameter((_) => _
            ..name = accessor.displayName
            ..type = refer('PropertyCallback<${ getAccessorFunctionName(accessor, short: true) }>?')
            ..named = true,
          ),
      ])
      ..body = Code('''
        return SubjectSubscription.fromExecutions([
          ${
            [
              ...methods.map((method) => '''
                if (${ method.displayName } != null) _controller.onMethod<${ method.toCodeType().toSource() }>('${ method.displayName }', ${ method.displayName }${ before ? ', before: true' : '' }),
              ''',),
              ... accessors.map((accessor) => '''
                if (${ accessor.displayName } != null) _controller.onProperty('${ accessor.displayName }', ${ accessor.displayName }${ before ? ', before: true' : '' }),
              ''',),
            ].join()
          }
        ]);
      ''');
    });

  Method getOverrideMethod(MethodElement method) =>
    method.toCode().rebuild((_) => _
      ..annotations.add(refer('override'))
      ..body = Code('''
        _controller.method('${method.displayName}', (${ getMethodFunctionName(method) } callback) => ${ method.toCodeInvoke(target: refer('callback')).toSource() }, before: true);
        final result = super.${method.name}${ method.toCodeInvoke().toSource() };
        _controller.method('${method.displayName}', (${ getMethodFunctionName(method) } callback) => ${ method.toCodeInvoke(target: refer('callback')).toSource() });
        return result;
      '''),
    );

  Method getOverrideProperty(PropertyAccessorElement property) =>
    property.toCode().rebuild((_) => _
      ..returns = null
      ..annotations.add(refer('override'))
      ..requiredParameters.clear()
      ..requiredParameters.add(
        Parameter((_) => _
          ..name = 'value'
          ..type = property.variable.type.toCode(),
        ),
      )

      ..body = Code('''
        final previous = super.${property.displayName};
        _controller.property('${property.displayName}', value, previous, before: true);
        super.${property.displayName} = value;
        _controller.property('${property.displayName}', value, previous);
      '''),
    );
    
  String getMethodFunctionName(MethodElement method, { bool short = false }) =>
    '${ element.displayName }Subject${ method.displayName.toPascalCase() }Method${ element.toCodeTypes(short: short) }';

  String getAccessorFunctionName(PropertyAccessorElement accessor, { bool short = false }) =>
    '${ element.displayName }Subject${ accessor.displayName.toPascalCase() }Accessor${ element.toCodeTypes(short: short) }';

  /* -= Elements =- */

  String get subject => '''
    ${
      [
        if (element.isAbstract) 'abstract',
        'class', subjectName + element.toCodeTypes(),
        '=', element.toCodeType().toSource(),
        'with',
          '$observableName${element.toCodeTypes()}', ',',
          '_$subjectName${element.toCodeTypes()}', ';',
      ].join(' ')
    }
    $subjectMixin
  ''';

  String get subjectMixin => 
    Mixin((_) => _
      ..name = '_$subjectName'
      ..types.addAll(element.typeParameters.map((type) => type.toCode()))
      ..on = refer('$observableName${element.toCodeTypes()}, ${ element.toCodeType().toSource() }')

      /* -= Overrides =- */

      ..methods.addAll([
        for (final method in methods) getOverrideMethod(method),
        for (final accessor in accessors) getOverrideProperty(accessor),
      ]),
    ).toSource();

  String get observable => 
    Mixin((_) => _
      ..name = observableName
      ..types.addAll(element.typeParameters.map((type) => type.toCode()))
      ..implements.add(refer('ObservableSubjectClass'))
    
      /* -= Controller and Observable =- */

      ..fields.add(
        Field((_) => _
          ..name = '_controller'
          ..assignment = Code('ObservableSubjectController(${ !sync ? 'sync: false' : '' })')
          ..modifier = FieldModifier.final$,
        ),
      )
      
      ..methods.add(
        Method((_) => _
          ..name = 'subject'
          ..type = MethodType.getter
          ..returns = refer('ObservableSubject')
          ..annotations.add(refer('override'))
          ..body = const Code('return _controller.subject;'),
        ),
      )

      /* -= Listening =- */

      ..methods.addAll([
        createOn(),
        createOn(before: true),
      ]),
    ).toSource();

  /* -= Source =- */

  String toSource() =>
    [
      methodTypes,
      accessorTypes,
      subject,
      observable,
    ].join('\n');
}
