// ignore_for_file: avoid_print

import 'dart:io';

import 'package:subject/src/utils/process.dart';

enum SDK { dart, flutter }

/* -= Install Developer Dependency: subject_gen =- */

Future<Process> installGenerator({ SDK sdk = SDK.dart }) async =>
  sdk == SDK.dart
    ? (await Process.start('dart', [ 'pub', 'add', '--dev', 'subject_gen' ])).toPrint()
    : (await Process.start('flutter', [ 'pub', 'add', '--dev', 'subject_gen' ])).toPrint();

/* -= Run build_runner: build/watch =- */

Future<Process> runSubject({ bool watch = false, SDK sdk = SDK.dart }) async =>
  sdk == SDK.dart
    ? (await Process.start('dart', [ 'run', 'build_runner', if (watch) 'watch' else 'build' ])).toPrint()
    : (await Process.start('flutter', [ 'pub', 'run', 'build_runner', if (watch) 'watch' else 'build' ])).toPrint();

Future<Process> buildSubject({ SDK sdk = SDK.dart }) => runSubject(sdk: sdk);
Future<Process> watchSubject({ SDK sdk = SDK.dart }) => runSubject(watch: true, sdk: sdk);
