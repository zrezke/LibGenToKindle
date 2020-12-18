import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// ADD KEY
class Backend {
  String apiKey = "";

  Dio dio = new Dio();
  Future <Map> apiCall(String request) async{
    try{
      print(request);
      Response response = await dio.get(
        request,
        options: Options(
          headers: {
            "Keep-Alive": "timeout=1"
          }
        )
        );


    if (response.statusCode == 200) { 
      Map result = Map.castFrom(response.data);
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
  Future downloadFile(String uri, String title, String fileExt, BuildContext context) async{
    PermissionHandler permissionHandler = new PermissionHandler();
    var storagePermission = await permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (storagePermission[PermissionGroup.storage] == PermissionStatus.granted) {
      Directory dir = await getExternalStorageDirectory();
      final String _dirPath = dir.path;
      final String absDir = await new Directory("$_dirPath/donwloads")
        .create(recursive: true)
        .then((Directory directory) {
          return directory.absolute.path;
      });
      Response downloadLink = await dio.get(uri); 
      return dio.download(downloadLink.toString(), "$absDir/$title.$fileExt");
    }
    else  {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Enable file system permissions to use this functionality")
      ));
      return null;
    }

  }

}
