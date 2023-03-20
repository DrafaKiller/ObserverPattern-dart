import 'dart:io';

extension PipeProcess on Process {
  Process toStd() {
    stdout.addStream(this.stdout);
    stderr.addStream(this.stderr);
    return this;
  }
}
