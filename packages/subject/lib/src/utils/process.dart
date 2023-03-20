import 'dart:io';

extension PipeProcess on Process {
  Process toPrint() {
    this.stdout.listen((event) => stdout.add(event));
    this.stderr.listen((event) => stderr.add(event));
    return this;
  }
}
