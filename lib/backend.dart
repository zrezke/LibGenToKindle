import 'dart:convert';
import 'package:http/http.dart' as http;


class Backend {

  Future <Map> apiCall(String request) async{
    print(request);
    http.Response response = await http.get(request);
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    }
    else {
      return {"Message": "Something went wrong :("};
    }
  }

}
