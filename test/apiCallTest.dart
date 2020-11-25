import 'dart:async';
import 'dart:io';

import 'package:GenLibToKindle/backend.dart';


class Test extends Backend{
  void run() async{
    Map res = await convertApi();
    print(res.toString() + "\n");
    downloadFile(res["output"][0]["uri"]);
  }
}

void main() {
  Test t = new Test();
  t.run();
}