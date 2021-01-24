import 'package:flutter/material.dart';
import './borrow_report.dart';
import './booking_report.dart';
import './fines_report.dart';

class ReportGenerator extends StatefulWidget {
  @override
  _ReportGeneratorState createState() => _ReportGeneratorState();
}

class _ReportGeneratorState extends State<ReportGenerator>
    with SingleTickerProviderStateMixin {
  TabController reportTabs;
  @override
  void initState() {
    reportTabs = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          // filterList(index: reportTabs.index);
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Report Generator"),
            actions: [
              /* 
              Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => filter(context, filterItemList),
                );
              }), */
              // IconButton(
              //   icon: Icon(Icons.print_rounded),
              //   onPressed: null,
              // )
            ],
            bottom: TabBar(
              controller: reportTabs,
              tabs: [
                Tab(
                  icon: Icon(Icons.auto_stories),
                  child: Text("Borrow"),
                ),
                Tab(
                  icon: Icon(Icons.monetization_on),
                  child: Text("Fines"),
                ),
                Tab(
                  icon: Icon(Icons.event_available),
                  child: Text("Bookings"),
                ),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
            )),
        body: TabBarView(
          controller: reportTabs,
          children: [
            BorrowReport(),
            FinesReport(),
            BookingReport(),
          ],
        ));
  }

//? Filter Button display
  /*  filter(BuildContext context,
      List<DropdownMenuItem<filterSettings>> filterItemList) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      //~ Graph Settings: x-axis
                      child: Text("Graph Settings",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "X-Axis: ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          DropdownButton<filterSettings>(
                              value: xAxisFilter,
                              items: [
                                DropdownMenuItem(
                                    value: filterSettings.years,
                                    child: Text("Years")),
                                DropdownMenuItem(
                                    value: filterSettings.month,
                                    child: Text("Month"))
                              ],
                              onChanged: (value) => setState(() {
                                    xAxisFilter = value;
                                  })),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        //~ Record List Settings
                        "List Settings",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sort By: ", style: TextStyle(fontSize: 18)),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          DropdownButton<filterSettings>(
                              value: listFilter,
                              items: filterItemList,
                              onChanged: (value) => setState(() {
                                    listFilter = value;
                                  })),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

//? Dropdown menu items for the filter List settings
  filterList({int index = 0}) {
    List<DropdownMenuItem<filterSettings>> items = [];
    print(index);
    if (index == 0) {
      items.addAll([
        DropdownMenuItem(value: filterSettings.listYear, child: Text("Year")),
        DropdownMenuItem(
            value: filterSettings.bookTitle, child: Text("Book Titles"))
      ]);
    } else {
      items.addAll([
        DropdownMenuItem(value: filterSettings.listYear, child: Text("Fines")),
        DropdownMenuItem(
            value: filterSettings.bookTitle, child: Text("Students"))
      ]);
    }
    filterItemList = items;
  }

 */
}
