import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'backend.dart';
import 'utils.dart';


class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic apiCall;
  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
      });
    });

    super.initState();
  }


  Utils utils = Utils();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Map applyedFilters = {};
  List searchResults = ["N1", "N2"];
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


  Widget mainWidget({apiCall}) {
  if (apiCall == null) {  
    return  Image(
        image: AssetImage("assets/images/GenLibLogo.png")
      );
    }

  else {
    return FutureBuilder(
      future: apiCall,
      builder: (context, AsyncSnapshot <Map> data) {
        Widget returnWidget;
        if (data.hasData) {
          List keys = data.data.keys.toList();
          returnWidget = 
           ListView.builder(
            itemCount: data.data.keys.length,
            itemBuilder: (context, index) {
              String title = data.data[keys[index]]["title"];
              print(title);
              return Card(
                child: ListTile(
                  title: Text(title),
                ),
              );
            }
          );
       }
       else {
         returnWidget = CircularProgressIndicator();
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

  Drawer searchFilterDrawer(BuildContext context) {
    return Drawer(
    child: Column(
      children: <Widget>[
        DrawerHeader(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: Image(
            image: AssetImage("assets/images/GenLibLogo.png"),
            fit: BoxFit.cover,
            )
        ),  
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0)
        ),
        Divider(),
        Card(
          child: ListTile(
            title: Text("Search in:"), 
            subtitle: searchFiltersBuilder(context, 0),
          )
        ),
        Divider(),
        Card(
          child: ListTile(
            title: Text("Search with mask (word*)"), 
            subtitle: searchFiltersBuilder(context, 1),
          ),
        ),
        Divider(),
        Card(
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
    ),
  );
  }

  AppBar textFieldAppBar(BuildContext context) {
    return AppBar(
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
                  apiCall = Backend().apiCall(_request);
                });
                // Continue magic here
              },
            ),
          )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: textFieldAppBar(context),
      drawer: searchFilterDrawer(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: mainWidget(
            apiCall: apiCall
            )
        )
      )
    );
  }
}
