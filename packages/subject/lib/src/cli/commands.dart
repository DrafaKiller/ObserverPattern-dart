// ignore_for_file: avoid_print

import 'dart:io';

enum SDK {
  dart('dart'),
  flutter('flutter');

  const SDK(this.name);
  final String name; 
}

enum SubjectBuilderMessages {
  installGenerator('Installing "subject_gen" as a developer dependency...'),
  getDependencies('Getting dependencies...'),
  buildSubject('Building subject...'),
  watchSubject('Watching subject...');
  
  const SubjectBuilderMessages(this.message);
  final String message;

  @override
  String toString() =>
'''

  > [Subject] $message
''';
}

/* -= Get Dependencies =- */

Future<bool> isGeneratorInstalled({ SDK sdk = SDK.dart }) async {
  final result = await Process.run(
    sdk.name, [ 'pub', 'deps' ],
    runInShell: true,
  );

  return result.exitCode == 0 && result.stdout.toString().contains(' subject_gen ');
}

Future<Process> getDependencies({ SDK sdk = SDK.dart }) async =>
  Process.start(
    sdk.name, [ 'pub', 'get' ],
    mode: ProcessStartMode.inheritStdio,
    runInShell: true,
  );

/* -= Install Developer Dependency: subject_gen =- */

Future<Process> installGenerator({ SDK sdk = SDK.dart }) async =>
  Process.start(
    sdk.name, [ 'pub', 'add', 'subject_gen', '-d' ],
    mode: ProcessStartMode.inheritStdio,
    runInShell: true,
  );

/* -= Run build_runner: build/watch =- */

Future<Process> runSubject({ bool watch = false, SDK sdk = SDK.dart }) async =>
  Process.start(
    sdk.name, [ if (sdk == SDK.flutter) 'pub', 'run', 'build_runner', if (watch) 'watch' else 'build', ],
    mode: ProcessStartMode.inheritStdio,
    runInShell: true,
  );

Future<Process> buildSubject({ SDK sdk = SDK.dart }) => runSubject(sdk: sdk);
Future<Process> watchSubject({ SDK sdk = SDK.dart }) => runSubject(watch: true, sdk: sdk);
