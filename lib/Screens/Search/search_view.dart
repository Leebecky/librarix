import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Models/book.dart';
import 'package:librarix/Models/booking.dart';
import 'package:librarix/Models/borrow.dart';
import 'search_card.dart';

class SearchFunction extends StatefulWidget {
  final int index;
  SearchFunction({this.index});
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
      switch (widget.index) {
        case 1:
          for (var searchSnapshot in _allResults) {
            String title =
                    Book.fromSnapshot(searchSnapshot).title.toLowerCase(),
                isbn = Book.fromSnapshot(searchSnapshot).isbnCode.toString(),
                author = Book.fromSnapshot(searchSnapshot).author.toLowerCase();

            if (title.contains(_searchController.text.toLowerCase()) ||
                isbn.contains(_searchController.text.toString()) ||
                author.contains(_searchController.text.toLowerCase())) {
              showResults.add(searchSnapshot);
            }
          }
          break;
        case 2:
          for (var searchSnapshot in _allResults) {
            String userId =
                Borrow.fromSnapshot(searchSnapshot).userId.toLowerCase();

            if (userId.contains(_searchController.text.toLowerCase())) {
              showResults.add(searchSnapshot);
            }
          }
          break;
        case 3:
          for (var searchSnapshot in _allResults) {
            String userId =
                Booking.fromSnapshot(searchSnapshot).userId.toLowerCase();

            if (userId.contains(_searchController.text.toLowerCase())) {
              showResults.add(searchSnapshot);
            }
          }
          break;
      }
    } else {
      switch (widget.index) {
        case 2:
          _allResults.removeWhere(
              (element) => Borrow.fromSnapshot(element).status == "Cancelled");
          break;
        case 3:
          _allResults.removeWhere((element) =>
              Booking.fromSnapshot(element).bookingStatus == "Cancelled");
          break;
      }
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getSearchStreamSnapshots() async {
    QuerySnapshot data;
    switch (widget.index) {
      case 1:
        data =
            await FirebaseFirestore.instance.collection('BookCatalogue').get();
        break;
      case 2:
        data = await FirebaseFirestore.instance
            .collection("BorrowedBook")
            .where("BorrowStatus", isNotEqualTo: "Returned")
            .get();

        break;
      case 3:
        data = await FirebaseFirestore.instance
            .collection("Booking")
            .where("BookingStatus", isNotEqualTo: "Completed")
            .get();
        break;
      default:
        data =
            await FirebaseFirestore.instance.collection('BookCatalogue').get();
        break;
    }

    setState(() {
      _allResults = data.docs;
    });

    searchResultsList();
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
                  hintText: (widget.index == 1)
                      ? "Search by Book Title, Author or ISBN Code"
                      : "Search by User ID"),
            ),
            Expanded(
                child: (_resultsList.isNotEmpty)
                    ? ListView.builder(
                        itemCount: _resultsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          switch (widget.index) {
                            case 1:
                              return bookSearchCard(
                                  context, _resultsList[index]);
                            case 2:
                              return borrowSearchCard(
                                  context, _resultsList[index]);
                            case 3:
                              return bookingSearchCard(
                                  context, _resultsList[index]);

                            default:
                              return bookSearchCard(
                                  context, _resultsList[index]);
                          }
                        },
                      )
                    : Center(
                        child: Text(
                        (widget.index == 1)
                            ? "No books matching the search details found"
                            : "No records matching the search details found",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ))),
          ],
        ),
      ),
    );
  }
}
