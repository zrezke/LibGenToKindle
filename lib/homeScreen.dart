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
  List searchResults = ["N1", "N2"];

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
