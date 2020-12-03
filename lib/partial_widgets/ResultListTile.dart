import 'package:GenLibToKindle/backend.dart';
import 'package:flutter/material.dart';
import 'package:GenLibToKindle/utils.dart';

/// IMPLEMENT bookData for backend services.
/// await MultipartFile.fromFile(r"D:\dev\flutter\LibGenToKindle\lib\testFile.epub", filename:"testFile")

class ResultListTile extends StatelessWidget{
  final Function callback;
  ResultListTile(
    this.callback,
    {
    Key key,
    @required this.backend,
    @required double containerWidth,
    @required this.language,
    @required this.title,
    @required this.publisher,
    @required this.fileType,
    @required this.mirrors,
    @required this.author
  }) : _containerWidth = containerWidth, super(key: key);

  final double _containerWidth;
  final String language;
  final String title;
  final String publisher;
  final String fileType;
  final List mirrors;
  final List author;
  final Backend backend;
  static Map bookData;
  final Utils utils = Utils(); 


/// SO BASICALLY I SKULLFUCKED THE WHOLE SYSTEM XD
  @override
  Widget build(BuildContext context) {
    bookData = {
      "title": title, 
      "author": author
      };

    return Container(
      width: _containerWidth,
      alignment: Alignment.center,
      height: 100,
      child: Card(
        child: Container(
          child: Row(
            children: [
              Container(
                width: 75,
                color: Colors.black12,
                alignment: Alignment.center,
                child: Text(
                  language,
                  style: TextStyle(
                  )
                ),
              ),
              Container(
                child: new Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        Text(
                          title,
                        ),
                        Text(
                          publisher,
                          style: TextStyle(
                            fontSize: 12
                          )
                        )
                      ],
                    ),
                  )
                )
              ),

              /// Download button
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      IconButton(
                        icon: Icon(Icons.download_rounded
                        ),
                        onPressed: () {
                          String request = utils.buildRequest(type: "download", link: mirrors[0]);
                          callback(
                            backend.downloadFile(request, title, fileType));
                        },
                      ),
                      Text(
                        fileType,
                        style: TextStyle(
                          fontSize: 12
                        )
                      ) 
                    ]
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }

}
