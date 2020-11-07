import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;


class Backend {

  Future <Map> apiCall(String request) async{
    print(request);
    http.Response response = await http.get(request);
    int status = response.statusCode;
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    }
    else {
      throw HttpException("Couldn't complete api call (code: $status)");
    }
  }

}
