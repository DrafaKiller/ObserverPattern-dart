// ignore_for_file: avoid_print

import 'package:subject/src/cli/commands.dart';
import 'package:subject/src/utils/process.dart';

Future<void> main(List<String> args) async {
  final sdk = args.isNotEmpty && args.first.toLowerCase() == 'flutter' ? SDK.flutter : SDK.dart;

  if (!await isGeneratorInstalled(sdk: sdk)) {
    print(SubjectBuilderMessages.installGenerator);
    await installGenerator(sdk: sdk).when(
      success: () {
        print(SubjectBuilderMessages.getDependencies);
        return getDependencies(sdk: sdk).done;
      },
    );
  }

  print(SubjectBuilderMessages.buildSubject);
  await buildSubject(sdk: sdk).done;
}
