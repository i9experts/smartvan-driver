import 'dart:io';

/// A tiny real file for code paths that upload one.
File tempImage([String name = 'smartvan_test_image.png']) =>
    File('${Directory.systemTemp.path}/$name')
      ..writeAsBytesSync([137, 80, 78, 71]);
