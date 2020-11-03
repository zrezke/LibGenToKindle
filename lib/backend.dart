import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;


class Backend {

  dynamic apiCall(String request) async{
    http.Response response = await http.get(request);
    int status = response.statusCode;
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    else {
      throw HttpException("Couldn't complete api call (code: $status)");
    }
  }

}
