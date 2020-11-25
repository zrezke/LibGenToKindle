import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'package:dio/dio.dart';


class Backend {
  String apiKey = "<your api key here>";

  Dio dio = new Dio();
  Future <Map> apiCall(String request) async{
    try{
      http.Response response = await http.get(
        request,
        headers: {
          "Keep-Alive": "timeout=1"
        }
        );

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    }
    else {
      return {"Message": "Something went wrong :("};
    }
    }
    catch (ClientException) {
      return {"Message": "Something went wrong :("};
    }
  }
  
  Future <dynamic> convertApi({Map serverInfo}) async{
    Map <String, String> headers = {
        'x-oc-api-key': apiKey,
        'content-type': "multipart/form-data",
        'cache-control': "no-cache"
      };
    // Get server info, for future use if server info isn't available...
    if (serverInfo == null) {
      String url = "https://api2.online-convert.com/jobs";
      String body = """{

        "conversion": [
          {
            "category": "ebook",
            "target": "mobi"
          }
        ]
      }""";
      http.Response response = await http.post(url, headers: headers, body: body);
      Map result = jsonDecode(response.body);
      return convertApi(
        serverInfo: {
          "id": result["id"],
          "server": result["server"]
        }
      );
    }

    // Upload file to convert server.
    else {
      headers["x-oc-upload-uuid"] = randomString(10);
      FormData form = new FormData.fromMap({
        "title": "Six easy pieces",
        "author": "Richard Faymen",


        // ADD PATH TO DOWNLOADED FILE and FILE NAME programatically
        "file": await MultipartFile.fromFile(r"D:\dev\flutter\LibGenToKindle\lib\testFile.epub", filename:"testFile")
      
      
      });
      String url = serverInfo["server"] + "/upload-file/" + serverInfo["id"];
      Response response = await dio.post(url, data: form,options: Options(headers: headers));
      Map result = jsonDecode(response.toString());
      return checkConversionStatus(result["id"]["job"]);
    }

  }

  Future <Map> checkConversionStatus(String id) async{
    Map result = {"output": []};
    String url = "https://api2.online-convert.com/jobs/$id";
    while (result["output"].isEmpty) {
      Response response = await dio.get(url, options:Options(
        headers:{
          "x-oc-api-key": apiKey,
          "cache-control": "no-cache"
      }));
      result = jsonDecode(response.toString());
      sleep(Duration(seconds: 4));
    }
    return result;
  }

  void downloadFile(String uri) async{
    http.get(uri).then((response) {


      // Instead of test completed give it a propper name and stor it in a proper location!!!
        new File("testCompleted").writeAsBytes(response.bodyBytes);


  });
  }

}
