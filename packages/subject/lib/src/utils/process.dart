import 'dart:io';

extension PipeProcess on Process {
  Process toPrint() {
    stdout.addStream(this.stdout);
    stderr.addStream(this.stderr);
    return this;
  }
}
