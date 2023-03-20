import 'package:subject/src/cli/commands.dart';

Future<void> main() async {
  await installGenerator();
  await watchSubject();
}
