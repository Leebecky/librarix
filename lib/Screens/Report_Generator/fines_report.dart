import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Models/user.dart';
import 'package:librarix/modules.dart';
import './bar_chart_model.dart';
import 'bar_chart_model.dart';
import '../../Models/fines.dart';

class FinesReport extends StatefulWidget {
  @override
  _FinesReportState createState() => _FinesReportState();
}

class _FinesReportState extends State<FinesReport> {
//^ Bar Chart Data
  List<BarChartModel> bookingData = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ActiveUser>>(
        future: getAllUsers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ActiveUser>> snapshots) {
          if (snapshots.hasData) {
            //^ Retrieves all users and sorts by roles
            List<ActiveUser> lecturers = snapshots.data
                .where((detail) =>
                    detail.role == "Lecturer" || detail.role == "Admin")
                .toList();
            List<ActiveUser> students = snapshots.data
                .where((detail) =>
                    detail.role == "Student" || detail.role == "Librarian")
                .toList();

            lecturers.sort((a, b) => a.userId.compareTo(b.userId));
            students.sort((a, b) => a.userId.compareTo(b.userId));

            //^ Retrieving Fines Records Data
            return StreamBuilder<List<Fines>>(
                stream: getAllFines(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Fines>> fineSnapshot) {
                  var record = fineSnapshot.data;
                  if (fineSnapshot.hasData) {
                    generateChartData(record);

                    return SingleChildScrollView(
                      child: Column(children: [
                        //~ Chart Display
                        ExpansionTile(
                          title: Text("Fines Records Chart"),
                          initiallyExpanded: true,
                          children: [
                            BarChartGraph(
                              data: bookingData,
                              chartHeading: "Fines Records",
                              xHeading: "Years",
                            ),
                          ],
                        ),
                        Divider(),
                        //~ Displays list of all data, sorted by User role
                        ExpansionTile(
                          title: Text("Lecturers"),
                          children: [
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, i) => Divider(),
                                itemCount: lecturers.length,
                                itemBuilder: (context, i) {
                                  return ExpansionTile(
                                    title: Text(lecturers[i].userId),
                                    children: finesReportRecordList(
                                        record: record,
                                        userId: lecturers[i].userId),
                                  );
                                }),
                          ],
                        ),
                        Divider(),
                        ExpansionTile(
                          title: Text("Students"),
                          children: [
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, i) => Divider(),
                                itemCount: students.length,
                                itemBuilder: (context, i) {
                                  return ExpansionTile(
                                    title: Text(students[i].userId),
                                    children: finesReportRecordList(
                                        record: record,
                                        userId: students[i].userId),
                                  );
                                }),
                          ],
                        ),
                      ]),
                    );
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
  List<Widget> finesReportRecordList({List<Fines> record, String userId}) {
    List<Widget> recordList = [];
    var filtered = record.where((details) => details.userId == userId).toList();
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    for (var item in filtered) {
      recordList.add(ListTile(
        isThreeLine: true,
        title: Text(item.reason),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Total: RM${item.total}, to be paid by ${item.dueDate}"),
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
  void generateChartData(
    List<Fines> record,
  ) {
    Set xAxisTime = Set();
    List<Fines> measure = [];

    for (var item in record) {
      xAxisTime.add(parseStringToDate(item.dueDate).year.toString());
    }

    var sortedXAxis = xAxisTime.toList();
    sortedXAxis.sort();

    sortedXAxis.forEach((element) {
      for (var item in record) {
        if (parseStringToDate(item.dueDate).year.toString() == element) {
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
