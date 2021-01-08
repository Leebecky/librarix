import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/booking.dart';
import 'package:librarix/Models/discussion_room.dart';
import 'package:librarix/Models/study_table.dart';
import 'package:librarix/modules.dart';
import './bar_chart_model.dart';
import 'bar_chart_model.dart';

class BookingReport extends StatefulWidget {
  @override
  _BookingReportState createState() => _BookingReportState();
}

class _BookingReportState extends State<BookingReport> {
//^ Bar Chart Data
  List<BarChartModel> bookingData = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getStudyTables(), getAllRooms()]),
        builder: (BuildContext context, AsyncSnapshot snapshots) {
          if (snapshots.hasData) {
            //^ Retrieves all books in the libraryFacilities and sorts by title (alphabetically)
            List<StudyTable> st = snapshots.data[0];
            List<DiscussionRoom> dr = snapshots.data[1];

            st.sort((a, b) => a.tableNum.compareTo(b.tableNum));
            dr.sort((a, b) => a.roomNum.compareTo(b.roomNum));

            //^ Retrieving Borrow Record Data
            return StreamBuilder<List<Booking>>(
                stream: getAllBookings(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Booking>> bookingSnapshot) {
                  var record = bookingSnapshot.data;
                  if (bookingSnapshot.hasData) {
                    generateChartData(record);

                    return SingleChildScrollView(
                        child: Column(children: [
                      //~ Chart Display
                      ExpansionTile(
                        title: Text("Borrow Records Chart"),
                        initiallyExpanded: true,
                        children: [
                          BarChartGraph(
                            data: bookingData,
                            chartHeading: "Borrow Records",
                            xHeading: "Years",
                          ),
                        ],
                      ),
                      Divider(),
                      //~ Displays list of all data, sorted by Room Number
                      ExpansionTile(
                        title: Text("Discussion Rooms"),
                        children: [
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, i) => Divider(),
                              itemCount: dr.length,
                              itemBuilder: (context, i) {
                                return ExpansionTile(
                                  title: Text(dr[i].roomNum),
                                  children: bookingReportRecordList(
                                      record: record, facility: dr[i].roomNum),
                                );
                              }),
                        ],
                      ),
                      Divider(),
                      //~ Displays list of all data, sorted by Table Number
                      ExpansionTile(
                        title: Text("Study Tables"),
                        children: [
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, i) => Divider(),
                              itemCount: st.length,
                              itemBuilder: (context, i) {
                                return ExpansionTile(
                                  title: Text(st[i].tableNum),
                                  children: bookingReportRecordList(
                                      record: record, facility: st[i].tableNum),
                                );
                              }),
                        ],
                      )
                    ]));
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
  List<Widget> bookingReportRecordList(
      {List<Booking> record, String facility}) {
    List<Widget> recordList = [];
    var filtered =
        record.where((details) => details.roomOrTableNum == facility).toList();
    filtered.sort((a, b) => a.userId.compareTo(b.userId));
    for (var item in filtered) {
      recordList.add(ListTile(
        isThreeLine: true,
        title: Text(item.userId),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
              "Booking Period: ${item.bookingStartTime} - ${item.bookingEndTime} on ${item.bookingDate}"),
          Text("Status: ${item.bookingStatus}"),
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
  void generateChartData(
    List<Booking> record,
  ) {
    Set xAxisTime = Set();
    List<Booking> measure = [];

    for (var item in record) {
      xAxisTime.add(parseStringToDate(item.bookingDate).year.toString());
    }

    var sortedXAxis = xAxisTime.toList();
    sortedXAxis.sort();

    sortedXAxis.forEach((element) {
      for (var item in record) {
        if (parseStringToDate(item.bookingDate).year.toString() == element) {
          measure.add(item);
        }
      }

      bookingData.add(BarChartModel(
          xAxis: element,
          yAxis: measure.length,
          barColor: charts.ColorUtil.fromDartColor(
              BarChartModel.generateRandomColor())));
      measure = [];
    });
  }
}
