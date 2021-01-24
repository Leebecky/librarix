import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/book.dart';
import 'package:librarix/modules.dart';
import './bar_chart_model.dart';
import '../../Models/borrow.dart';
import 'bar_chart_model.dart';

class BorrowReport extends StatefulWidget {
  @override
  _BorrowReportState createState() => _BorrowReportState();
}

class _BorrowReportState extends State<BorrowReport> {
//^ Bar Chart Data
  List<BarChartModel> borrowData = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
        stream: getAllBooks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Book>> bookSnapshot) {
          if (bookSnapshot.hasData) {
            //^ Retrieves all books in the catalogue and sorts by title (alphabetically)
            var catalogue = bookSnapshot.data;
            catalogue.sort((a, b) =>
                a.title.toLowerCase().compareTo(b.title.toLowerCase()));
            //^ Retrieving Borrow Record Data
            return StreamBuilder<List<Borrow>>(
                stream: getAllBorrowRecords(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Borrow>> snapshot) {
                  var record = snapshot.data;
                  if (snapshot.hasData) {
                    generateChartData(record);

                    return Column(children: [
                      //~ Chart Display
                      ExpansionTile(
                        title: Text("Borrow Records Chart"),
                        initiallyExpanded: true,
                        children: [
                          BarChartGraph(
                            data: borrowData,
                            chartHeading: "Borrow Records",
                            xHeading: "Years",
                          ),
                        ],
                      ),
                      Divider(),
                      //~ Displays list of all data, sorted by Book Title
                      Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, i) => Divider(),
                            itemCount: catalogue.length,
                            itemBuilder: (context, i) {
                              return ExpansionTile(
                                title: Text(catalogue[i].title),
                                children: borrowReportRecordList(
                                    record: record,
                                    bookTitle: catalogue[i].title),
                              );
                            }),
                      )
                    ]);
                  }
                  return SpinKitWave(
                    color: Theme.of(context).accentColor,
                  );
                });
          }
          return SpinKitWave(
            color: Theme.of(context).accentColor,
          );
        });
  }

//? Returns a list of ListTile widgets containing borrow record data
  List<Widget> borrowReportRecordList({List<Borrow> record, String bookTitle}) {
    List<Widget> recordList = [];
    var filtered =
        record.where((details) => details.bookTitle == bookTitle).toList();
    filtered.sort((a, b) => a.userId.compareTo(b.userId));
    for (var item in filtered) {
      recordList.add(ListTile(
        isThreeLine: true,
        title: Text(item.userId),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Borrow Period: ${item.borrowedDate} - ${item.returnedDate}"),
          Text("Status: ${item.status}"),
        ]),
      ));
    }
    (recordList.isEmpty)
        ? recordList.add(ListTile(
            title: Text("No records found"),
          ))
        : recordList = recordList;
    return recordList;
  }

//? Generates the data needed to populate the chart based on given parameters
  void generateChartData(List<Borrow> record) {
    Set xAxisTime = Set();
    List<Borrow> measure = [];
    for (var item in record) {
      if (item.borrowedDate != "Not Available") {
        xAxisTime.add(parseStringToDate(item.borrowedDate).year.toString());
      }
    }

    xAxisTime.forEach((element) {
      for (var item in record) {
        if (item.status != "Reserved" &&
            parseStringToDate(item.borrowedDate).year.toString() == element) {
          measure.add(item);
        }
      }

      borrowData.add(BarChartModel(
          xAxis: element,
          yAxis: measure.length,
          barColor: charts.ColorUtil.fromDartColor(
              BarChartModel.generateRandomColor())));
      measure = [];
    });
  }
}
