import 'package:subject/src/cli/commands.dart';

Future<void> main(List<String> args) async {
  final sdk = args.isNotEmpty && args.first.toLowerCase() == 'flutter' ? SDK.flutter : SDK.dart;

  await installGenerator(sdk: sdk);
  await buildSubject(sdk: sdk);
}
