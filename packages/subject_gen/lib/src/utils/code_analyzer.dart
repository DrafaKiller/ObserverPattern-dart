import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/code_builder.dart' as code show FunctionType;

/* -= Basics =- */

extension SpecToCode on Spec {
  String toSource() => accept(DartEmitter()).toString();
}

/* -= Types =- */

extension DartTypeToCode on DartType {
  Reference toCode() => Reference(getDisplayString(withNullability: true));
}

extension ParameterizedTypeToCode on ParameterizedType {
  TypeReference toCode() => TypeReference((_) => _
    ..symbol = element?.name
    ..types.addAll(typeArguments.map((type) => type.toCode())),
  );
}

/* -= Commons =- */

extension ClassElementToCode on ClassElement {
  TypeReference toCodeType() => thisType.toCode();
}

extension MethodElementToCode on MethodElement {
  Method toCode() => Method((_) => _
    ..name = name
    ..returns = returnType.toCode()
    ..types.addAll(typeParameters.map((typeParameter) => typeParameter.toCode()))
    
    /* -= Parameters =- */
    ..requiredParameters.addAll([
      for (final parameter in parameters.where((parameter) => parameter.isRequired))
        parameter.toCode(),
    ])
    ..optionalParameters.addAll({
      for (final parameter in parameters.where((parameter) => parameter.isOptional))
        parameter.toCode(),
    }),
  );
}

/* -= Elements =- */

extension ParameterElementToCode on ParameterElement {
  Parameter toCode() => Parameter((_) => _
    ..name = name
    ..type = type.toCode()
    ..named = isNamed
    ..required = isRequiredNamed,
  );

  Reference toCodeReference() => Reference('${ type.toCode().toSource() } $name');
}

extension TypeParameterElementToCode on TypeParameterElement {
  TypeReference toCode() => TypeReference((_) => _
    ..symbol = name
    ..bound = bound?.toCode(),
  );
}

extension TypeParameterizedElementToCode on TypeParameterizedElement {
  String toCodeTypes({ bool short = false }) =>
    typeParameters.isEmpty ? '' : '<${ typeParameters.map((type) {
      final typeCode = type.toCode();
      return short ? typeCode.symbol : typeCode.toSource();
    }).join(', ') }>';
}

extension FunctionTypedElementToCode on FunctionTypedElement {
  code.FunctionType toCodeType() => code.FunctionType((_) => _
    ..symbol = name
    ..returnType = returnType.toCode()
    ..types.addAll(typeParameters.map((typeParameter) => typeParameter.toCode()))

    /* -= Parameters =- */
    ..optionalParameters.addAll({
      for (final parameter in parameters.where((parameter) => parameter.isOptionalPositional))
        parameter.toCodeReference(),
    })
    ..requiredParameters.addAll([
      for (final parameter in parameters.where((parameter) => parameter.isRequiredPositional))
        parameter.toCodeReference(),
    ])
    ..namedParameters.addAll({
      for (final parameter in parameters.where((parameter) => parameter.isOptionalNamed))
        parameter.name: parameter.type.toCode(),
    })
    ..namedRequiredParameters.addAll({
      for (final parameter in parameters.where((parameter) => parameter.isRequiredNamed))
        parameter.name: parameter.type.toCode(),
    }),
  );

  InvokeExpression toCodeInvoke({ Expression? target }) => InvokeExpression.newOf(
    target ?? const Reference(''),
    parameters.where((parameter) => parameter.isPositional).map((parameter) => refer(parameter.name)).toList(),
    {
      for (final parameter in parameters.where((parameter) => parameter.isNamed))
        parameter.name: refer(parameter.name),
    },
    typeParameters.map((typeParameter) => refer(typeParameter.name)).toList(),
  );
}

extension PropertyAccessorElementToCode on PropertyAccessorElement {
  Method toCode() => Method((_) => _
    ..name = displayName
    ..returns = returnType.toCode()
    ..types.addAll(typeParameters.map((typeParameter) => typeParameter.toCode()))
    ..type =
      isGetter ? MethodType.getter :
      isSetter ? MethodType.setter :
      null

    /* -= Parameters =- */
    ..requiredParameters.addAll([
      for (final parameter in parameters.where((parameter) => parameter.isRequired))
        parameter.toCode(),
    ])
    ..optionalParameters.addAll({
      for (final parameter in parameters.where((parameter) => parameter.isOptional))
        parameter.toCode(),
    }),
  );
}
