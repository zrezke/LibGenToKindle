import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

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
      },
      childCount: searchResults.length
    );
  }

  SliverAppBar appBar(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          children: [
            Container(
              child: Text(
                "GenLib To Kindle",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "Brutal"
                ),
                textAlign: TextAlign.center,
              )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
              child: TextField(
              ),
            )
          ]
        ),
      )
    );
  }



  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        appBar(context),
        SliverList(delegate: searchResultListView(context, searchResults))
      ],
    );
  }
}
