// ignore_for_file: avoid_print

import 'dart:io';

import 'package:subject/src/utils/process.dart';

/* -= Install Developer Dependency: subject_gen =- */

Future<Process> installGenerator() async =>
  (await Process.start('dart', [ 'pub', 'add', 'subject_gen', '-d' ])).toStd();

/* -= Run build_runner: build/watch =- */

Future<Process> runSubject({ bool watch = false }) async =>
 (await Process.start('dart', [ 'run', 'build_runner', if (!watch) 'build' else 'watch', '-d' ])).toStd();

Future<Process> buildSubject() => runSubject();
Future<Process> watchSubject() => runSubject(watch: true);
