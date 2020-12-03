import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:dio/dio.dart';

/// ADD KEY
class Backend {
  String apiKey = "";

  Dio dio = new Dio();
  Future <Map> apiCall(String request) async{
    try{
      Response response = await dio.get(
        request,
        options: Options(
          headers: {
            "Keep-Alive": "timeout=1"
          }
        )
        );


    if (response.statusCode == 200) { 
      Map result = Map.castFrom(response.data) as Map;
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
  
  Future <dynamic> convertApi({Map serverInfo, @required Map bookData}) async{
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
      Response response = await dio.post(url, options: Options(headers: headers), data: body);
      Map result = jsonDecode(response.data);
      return convertApi(
        bookData: bookData,
        serverInfo: {
          "id": result["id"],
          "server": result["server"]
        }
      );
    }

    // Upload file to convert server.
    else {
      headers["x-oc-upload-uuid"] = randomString(10);
      FormData form = new FormData.fromMap(
        // Title author mirrors
          bookData
        // ADD PATH TO DOWNLOADED FILE and FILE NAME programatically
      );
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

  /// WORK ON THIS ERROR: ADD PERMISSIONS TO WRITE FILES
  void downloadFile(String uri, String title, String fileExt) async{
    Response downloadLink = await dio.get(uri); 
    await dio.download(downloadLink.toString(), new File("download/$title.$fileExt"));
  }

}
