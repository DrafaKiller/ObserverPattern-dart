extension StringCase on String {
  RegExp get caseExpression => RegExp(r'(\s|_|(?=[A-Z]))+');

  String toCamelCase() {
    final words = split(caseExpression)
      .where((word) => word.isNotEmpty);
    if (words.isEmpty) return '';
    return [
      words.first.toLowerCase(),
      ... words
        .skip(1)
        .map((word) => '${ word[0].toUpperCase() }${ word.substring(1) }')
    ]
      .where((word) => word.isNotEmpty)
      .join();
  }

  String toSnakeCase() =>
    split(caseExpression)
      .where((word) => word.isNotEmpty)
      .map((word) => '${ word[0].toLowerCase() }${ word.substring(1) }')
      .join('_');

  String toPascalCase() =>
    split(caseExpression)
      .where((word) => word.isNotEmpty)
      .map((word) => '${ word[0].toUpperCase() }${ word.substring(1) }')
      .where((word) => word.isNotEmpty)
      .join();

  String toNormalCase() =>
    split(caseExpression)
      .where((word) => word.isNotEmpty)
      .join(' ');

  String toCapitalCase() =>
    split(caseExpression)
      .where((word) => word.isNotEmpty)
      .map((word) => '${ word[0].toUpperCase() }${ word.substring(1) }')
      .join(' ');
}
