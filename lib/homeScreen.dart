import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

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

  AppBar appBar(BuildContext context) {
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
            
              onSubmitted: (String searchQuery) {
                
              },
            ),
          )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: appBar(context),
      drawer: searchFilterDrawer(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      )
    );
  }
}
