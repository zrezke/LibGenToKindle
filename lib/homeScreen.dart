import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'backend.dart';
import 'utils.dart';
import 'partial_widgets/ResultListTile.dart';


class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic apiCall;
  dynamic _previousData;
  final Backend backend = new Backend();
  @override
  void initState() {
      setState(() {
      });

    super.initState();
  }

  void callback(Future _apicall) {
    setState(() {
      apiCall = _apicall;
    });
  }


  Utils utils = Utils();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Map applyedFilters = {};
  Map searchFilterItems = {
    "Search in": [
      "LibGen(Sci-Tech)",
      "Scientific articles",
      "Fiction",
      "Comics",
      "Standards",
      "Magazines"
      ],
      "Search with mask (word*)": [
        "No",
        "Yes"
        ],
      "Search in fields": [
        "The column set to default",
        "Title",
        "Author(s)",
        "Series",
        "Publisher",
        "Year",
        "ISBN",
        "Language",
        "MD5",
        "Tags",
        "Extension"
      ]
    };

  //  Returns user to default home screen on back button press
  //  after bad API call.
  Future <bool> _onWillPop() async{
    setState(() {
      apiCall = null;
    });
    return false;
  }

  SliverChildBuilderDelegate searchResultListView(
      BuildContext context, List searchResults) {
    return SliverChildBuilderDelegate((context, index) {
      return Card(
        child: ListTile(
            title: Text(
              searchResults[index],
            ),
            onTap: () {}),
        color: Colors.white,
      );
    }, childCount: searchResults.length);
  }

  List <DropdownMenuItem <String>> _makeDropdownMenuItems(String key) {
    List <DropdownMenuItem <String>> items = [];
    for (int i=0; i< searchFilterItems[key].length; i++) {
      String val = searchFilterItems[key][i];
      DropdownMenuItem <String> item = DropdownMenuItem(
        value: val,
        child: Text(
          val
        )
      );
      items.add(item);
    }
    return items; 
  }

  void _getHint(hint, String key, int idx) {
    if (hint == null) {
      hint = searchFilterItems[key][0];
    }
    else {
      hint = hint;
    }
    return hints.replaceRange(idx, idx+1, [hint]);
  }

  List hints = [null, null, null];

  Widget widgetManager({apiCall}) {
  if (apiCall == null) {  
    return  Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 150),
        child: Text(
          "Library Genesis",
          textAlign: TextAlign.center,
          style: GoogleFonts.knewave(
            fontSize: 40,
            color: Color(0x99ffffff)
          )
        ),
      )
    );
    }

  else {
    return FutureBuilder(
      future: apiCall,
      builder: (context, AsyncSnapshot data) {
        Widget returnWidget;
        if (data.hasData && data.data != _previousData) {
          _previousData = data.data;
          List keys = data.data.keys.toList();
          
          // If: no usable info from API
          if (keys.contains("Message")) {
            returnWidget = 
            WillPopScope(
              onWillPop: _onWillPop,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 150),
                  child: Text(
                    'Sorry, \n' + 
                      data.data["Message"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.zillaSlab(
                      fontSize: 30,
                      color: Color(0x99ffffff)
                    )
                  ),
                )
              )
            );
          }
          ///  If: API CALL RETURNED SEARCH RESULTS
          else{
            returnWidget = 
              ListView.builder(
                itemCount: data.data.keys.length,
                itemBuilder: (context, index) {
                double _containerWidth = 
                  MediaQuery.of(context).size.width * 0.8;
                  var item = data.data[keys[index]];
                  String title = item["title"];
                  List author = item["author"];
                  String publisher = item["publisher"];
                  String year = item["year"];
                  String language = item["language"];
                  String size = item["size"];
                  String fileType = item["fileType"];
                  List mirrors = item["mirrors"];
                  
                  return ResultListTile(
                    this.callback,
                    backend: this.backend,
                    containerWidth: _containerWidth,
                    language: language,
                    title: title,publisher: publisher,
                    fileType: fileType,
                    mirrors: mirrors,
                    author: author
                  );
                }
              );
            }
          }
        /// IF API IS NOT FINISHED YET SHOW PROGRESS INDICATOR
       else {
         returnWidget = Center(
          child: CircularProgressIndicator(
          )
         );
       }
       
      return returnWidget;
      }
    );
  }

}

  DropdownButton searchFiltersBuilder(BuildContext context, int idx) {
    String key = searchFilterItems.keys.toList()[idx];
    _getHint(hints[idx], key, idx);
    var hint = hints[idx];
    return DropdownButton(
      style: TextStyle(
        ),
      key: Key(idx.toString()),
      hint: Text(hint),
      items: _makeDropdownMenuItems(key),
      value: null,
      onChanged: (value) {
        applyedFilters[key] = value;
        setState(() {
          hints[idx] = value;
        });
      },
    );
  }

  Widget searchFilterDrawer(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
       canvasColor: Color(0x57000000)
      ),
    child: Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              child: Container(
                padding: EdgeInsets.only(
                  top:45
                  ),
                child: Text(
                  "Library Genesis",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.knewave(
                    color: Colors.white,
                    fontSize: 30
                  ),
                )
              )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0)
            ),
            Divider(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffffffff),
              ),
              child: ListTile(
                title: Text(
                  "Search in:",
                  ), 
                subtitle: searchFiltersBuilder(context, 0),
              )
            ),
            Divider(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffffffff),
              ),
              child: ListTile(
                title: Text("Search with mask (word*)"), 
                subtitle: searchFiltersBuilder(context, 1),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffffffff),
              ),
              child: ListTile(
                title: Text("Search in fields"), 
                subtitle: searchFiltersBuilder(context, 2),
              )
            ),
            FlatButton(
              color: Colors.amber,
              child: Text("Reset to default"),
              onPressed: () {
                setState(() {
                  hints = [null, null, null];
                });
              },
            )
          ],
        )
      )
    )
    );
  }

  AppBar textFieldAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffD59600),
      iconTheme: IconThemeData(color: Colors.white, size: 44),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _drawerKey.currentState.openDrawer();
        },
        ),
        title: Container(
            child: CupertinoTextField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              prefix: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Icon(Icons.search, color: Colors.grey, size: 28),
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),

              placeholder: "Search millions of books",
            
              onSubmitted: (String searchQuery) async {
                String _request = utils.buildRequest(
                  type: "search",
                  query: searchQuery,
                  filters: hints
                  );
                setState(() {
                  apiCall = this.backend.apiCall(_request);
                });
              },
            ),
          )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _drawerKey,
      appBar: textFieldAppBar(context),
      drawer: searchFilterDrawer(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomRight,
              begin: Alignment.topRight,
              colors: <Color> [
                Color(0xffE2A001),
                Color(0xff4E4226)]
            )
          ),
          child: widgetManager(
            apiCall: apiCall
            )
        )
      )
    );
  }
}
