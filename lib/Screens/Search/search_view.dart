import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/book.dart';
import 'search_card.dart';

class SearchFunction extends StatefulWidget {
  @override
  _SearchFunctionState createState() => _SearchFunctionState();
}

class _SearchFunctionState extends State<SearchFunction> {
  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getSearchStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var searchSnapshot in _allResults) {
        var title = Book.fromSnapshot(searchSnapshot).title.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(searchSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getSearchStreamSnapshots() async {
    var data =
        await FirebaseFirestore.instance.collection('BookCatalogue').get();

    setState(() {
      _allResults = data.docs;
    });

    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search by book name or ISBN Code"),
            ),
            Expanded(
                child: (_resultsList.isNotEmpty)
                    ? ListView.builder(
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildSearchCard(context, _resultsList[index]),
                      )
                    : Center(
                        child: Text(
                        "No books matching the search details found",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ))),
          ],
        ),
      ),
    );
  }
}
