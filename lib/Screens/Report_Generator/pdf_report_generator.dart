import 'dart:io';
import 'dart:math';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:pdf/widgets.dart' as pw;
import 'package:librarix/modules.dart';
import 'package:librarix/Models/borrow.dart';
import 'package:librarix/Models/discussion_room.dart';
import 'package:librarix/Models/study_table.dart';
import 'package:librarix/Screens/Notifications/notifications_build.dart';
import '../../Models/booking.dart';
import '../../Models/fines.dart';
import '../../Models/book.dart';
import '../../Models/user.dart';

//? PDF Generator
Future generatePdfReport(material.BuildContext context,
    PdfPageFormat pageFormat, int tabIndex) async {
  String reportType;
  List<Book> bookList = [];
  List<Borrow> borrowList = [];
  List<Fines> finesList = [];
  List<Booking> bookingList = [];
  List<ActiveUser> userList = [];
  List<DiscussionRoom> roomList = [];
  List<StudyTable> studyTableList = [];

//^ Retrieves the relevant records for producing the report
  switch (tabIndex) {
    case 0:
      reportType = "Borrow";
      await for (var item in getAllBorrowRecords()) {
        borrowList = item;
      }
      await for (var item in getAllBooks()) {
        bookList = item;
      }
      break;
    case 1:
      reportType = "Fines";
      await for (var item in getAllFines()) {
        finesList = item;
      }
      userList = await getAllUsers();
      break;
    case 2:
      reportType = "Booking";
      await for (var item in getAllBookings()) {
        bookingList = item;
      }
      studyTableList = await getStudyTables();
      roomList = await getAllRooms();
      break;
  }

//? Generates the pdf document and controls layout

  //^ Create pdf document
  pw.Document report = pw.Document();

  //^ Add pages to the document
  report.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: pageFormat,
      build: (context) => [
            TextWidget("$reportType Report", fontSize: 30),
            pw.SizedBox(height: 30),
            //~ Bar chart
            _barChart(context,
                borrowList: borrowList,
                finesList: finesList,
                bookingList: bookingList),
            pw.SizedBox(height: 30),
            //~ Table
            pw.Column(
                children: _recordTable(context,
                    borrowList: borrowList,
                    finesList: finesList,
                    bookList: bookList,
                    userList: userList,
                    studyTableList: studyTableList,
                    bookingList: bookingList,
                    roomList: roomList))
          ]));

  //^ Save and display pdf
  final String dir = (await getExternalStorageDirectory()).path;
  final String path = '$dir/$reportType Report.pdf';
  final File file = File(path);
  await file.writeAsBytes(await report.save());
  var message = {
    "Title": "LibrariX Report Generator",
    "Body": "$reportType report PDF has been saved. ",
    "Payload": "$path"
  };
  await standardNotification(message);
}

//? Report Bar Chart
pw.Widget _barChart(pw.Context context,
    {List<Borrow> borrowList,
    List<Fines> finesList,
    List<Booking> bookingList}) {
  List<List<Object>> dataSet;

  //^ If requested report is Borrow
  (borrowList.isNotEmpty)
      ? dataSet = generateBorrowBarChart(borrowList)
      : (finesList.isNotEmpty)
          //^ If requested report is Fines
          ? dataSet = generateFinesChart(finesList)
          //^ If requested report is Booking
          : dataSet = generateBookingChart(bookingList);

  //^ The y-axis headers are generated from the dataset
  List<int> yHeaders = generateYAxisHeaders(dataSet);

  //^ Building the bar chart
  return pw.SizedBox(
      height: 300,
      child: pw.Chart(
        left: pw.Container(
          alignment: pw.Alignment.topCenter,
          margin: const pw.EdgeInsets.only(right: 5, top: 10),
          child: pw.Transform.rotateBox(
            angle: pi / 2,
            child: pw.Text('Number of Records'),
          ),
        ),
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis.fromStrings(
            List<String>.generate(
                dataSet.length, (index) => dataSet[index][0].toString()),
            marginStart: 50,
            marginEnd: 30,
            ticks: true,
          ),
          yAxis: pw.FixedAxis(
            yHeaders,
            divisions: true,
          ),
        ),
        datasets: [
          //~ Generates the bars
          pw.BarDataSet(
            color: PdfColors.grey700,
            width: 30,
            data: List<pw.LineChartValue>.generate(
              dataSet.length,
              (i) {
                final num v = int.parse(dataSet[i][1].toString());
                return pw.LineChartValue(i.toDouble(), v.toDouble());
              },
            ),
          ),
        ],
      ));
}

//? Report Data Table
List<pw.Widget> _recordTable(pw.Context context,
    {List<Borrow> borrowList,
    List<Book> bookList,
    List<Fines> finesList,
    List<ActiveUser> userList,
    List<StudyTable> studyTableList,
    List<Booking> bookingList,
    List<DiscussionRoom> roomList}) {
  //^ Borrow Report
  if (borrowList.isNotEmpty) {
    List<String> bookTitle = [];
    for (Book book in bookList) {
      bookTitle.add(book.title);
    }
    bookTitle.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return generateBorrowTable(borrowList, bookTitle);
  }
  //^ Fines Report
  else if (finesList.isNotEmpty) {
    List<String> userId = [];
    for (ActiveUser user in userList) {
      userId.add(user.userId);
    }
    return generateFinesTable(finesList, userId);
  }
  //^ Booking Report
  else {
    List<pw.Widget> widgetList = [];
    List<pw.Widget> dr =
        generateDiscussionRoomBookingTable(bookingList, roomList);
    List<pw.Widget> st =
        generateStudyTableBookingTable(bookingList, studyTableList);

    //~ Combines the results of discussion room + study table
    widgetList.addAll([
      TextWidget("Discussion Room", fontSize: 20, header: true),
      pw.SizedBox(height: 20)
    ]);
    dr.forEach((element) {
      widgetList.add(element);
    });

    widgetList.addAll([
      pw.SizedBox(height: 20),
      TextWidget("Study Table", fontSize: 20, header: true),
      pw.SizedBox(height: 20)
    ]);
    st.forEach((element) {
      widgetList.add(element);
    });
    return widgetList;
  }
}

//~ Bar Chart Data Generators
//? Generates the y Axis headers
List<int> generateYAxisHeaders(List<List<Object>> dataSet) {
  List<int> values = [], headers = [];
  int increment;
  for (int i = 0; i < dataSet.length; i++) {
    values.add(int.parse(dataSet[i][1].toString()));
  }
  values.sort((a, b) => a.compareTo(b));
  int highest = values.last;
  int num = ((highest / 10).ceil() * 10);
  (num < 40) ? increment = 5 : increment = 10;

  for (int i = 0; i <= (num / increment); i++) {
    headers.add(i * increment);
  }
  return headers;
}

//? Generate Borrow bar chart
List<List<Object>> generateBorrowBarChart(List<Borrow> borrowList) {
  List<List<Object>> data = [];
  Set xAxisTime = Set();
  List<Borrow> recordTotal = [];

  for (var item in borrowList) {
    if (item.borrowedDate != "Not Available") {
      xAxisTime.add(parseStringToDate(item.borrowedDate).year.toString());
    }
  }

  xAxisTime.forEach((element) {
    for (var item in borrowList) {
      if ((item.status == "Borrowed" || item.status == "Returned") &&
          parseStringToDate(item.borrowedDate).year.toString() == element) {
        recordTotal.add(item);
      }
    }
    data.add([element, recordTotal.length]);
    recordTotal = [];
  });
  return data;
}

//? Generate Fines Bar chart
List<List<Object>> generateFinesChart(List<Fines> finesList) {
  List<List<Object>> data = [];
  Set xAxisTime = Set();
  List<Fines> recordTotal = [];

  for (var item in finesList) {
    xAxisTime.add(parseStringToDate(item.issueDate).year.toString());
  }

  var sortedXAxis = xAxisTime.toList();
  sortedXAxis.sort();

  sortedXAxis.forEach((element) {
    for (var item in finesList) {
      if (parseStringToDate(item.issueDate).year.toString() == element) {
        recordTotal.add(item);
      }
    }

    data.add([element, recordTotal.length]);
    recordTotal = [];
  });
  return data;
}

//? Generate Booking bar chart
List<List<Object>> generateBookingChart(List<Booking> bookingList) {
  Set xAxisTime = Set();
  List<Booking> recordTotal = [];
  List<List<Object>> data = [];

  for (var item in bookingList) {
    xAxisTime.add(parseStringToDate(item.bookingDate).year.toString());
  }

  var sortedXAxis = xAxisTime.toList();
  sortedXAxis.sort();

  sortedXAxis.forEach((element) {
    for (var item in bookingList) {
      if (parseStringToDate(item.bookingDate).year.toString() == element) {
        recordTotal.add(item);
      }
    }

    data.add([element, recordTotal.length]);
    recordTotal = [];
  });
  return data;
}

//~ Table Data Generator
//? Borrow Data Table
List<pw.Widget> generateBorrowTable(
    List<Borrow> borrowList, List<String> titleList) {
  List<List<Object>> recordList = [];
  List<pw.Widget> tableList = [];
  List<String> tableHeader = ["ID", "Borrow Period", "Status"];

  //^ Retrieve corresponding records
  titleList.forEach((title) {
    borrowList.forEach((record) {
      if (record.bookTitle == title) {
        recordList.add([
          record.userId,
          "${record.borrowedDate}-${record.returnedDate}",
          record.status
        ]);
      }
    });

    //^ Constructs the data table
    if (recordList.isNotEmpty) {
      tableList.addAll([
        TextWidget(title),
        DataTable(recordList: recordList, tableHeader: tableHeader),
        pw.SizedBox(height: 20)
      ]);
    }
    recordList = [];
  });
  return tableList;
}

//? Fines Data Table
List<pw.Widget> generateFinesTable(List<Fines> finesList, List<String> userId) {
  List<List<Object>> recordList = [];
  List<pw.Widget> tableList = [];
  List<String> tableHeader = ["Reason", "Total", "Issue Date", "Status"];

  //^ Retrieve corresponding records
  userId.forEach((user) {
    finesList.forEach((record) {
      if (record.userId == user) {
        recordList.add([
          record.reason,
          "RM${record.total}",
          record.issueDate,
          record.status
        ]);
      }
    });

    //^ Constructs the data table
    if (recordList.isNotEmpty) {
      tableList.addAll([
        TextWidget(user),
        DataTable(recordList: recordList, tableHeader: tableHeader),
        pw.SizedBox(height: 20)
      ]);
    }

    recordList = [];
  });
  return tableList;
}

//? Booking Data Table - Discussion Room
List<pw.Widget> generateDiscussionRoomBookingTable(
    List<Booking> bookingList, List<DiscussionRoom> roomList) {
  List<List<Object>> recordList = [];
  List<pw.Widget> tableList = [];
  List<String> tableHeader = ["ID", "Date", "Booking Period", "Status"];

  //^ Retrieve corresponding records
  roomList.sort((a, b) => a.roomNum.compareTo(b.roomNum));
  roomList.forEach((room) {
    bookingList.forEach((record) {
      if (record.roomOrTableNum == room.roomNum) {
        recordList.add([
          record.userId,
          record.bookingDate,
          "${record.bookingStartTime}-${record.bookingEndTime}",
          record.bookingStatus
        ]);
      }
    });

    //^ Constructs the data table
    if (recordList.isNotEmpty) {
      tableList.addAll([
        TextWidget(room.roomNum),
        DataTable(recordList: recordList, tableHeader: tableHeader),
        pw.SizedBox(height: 20)
      ]);
    }

    recordList = [];
  });

  return tableList;
}

//? Booking Data Table - Study Table
List<pw.Widget> generateStudyTableBookingTable(
    List<Booking> bookingList, List<StudyTable> studyTableList) {
  List<List<Object>> recordList = [];
  List<pw.Widget> tableList = [];
  List<String> tableHeader = ["ID", "Date", "Booking Period", "Status"];

  //^ Retrieve corresponding records
  studyTableList.sort((a, b) => a.tableNum.compareTo(b.tableNum));
  studyTableList.forEach((table) {
    bookingList.forEach((record) {
      if (record.roomOrTableNum == table.tableNum) {
        recordList.add([
          record.userId,
          record.bookingDate,
          "${record.bookingStartTime}-${record.bookingEndTime}",
          record.bookingStatus
        ]);
      }
    });

    //^ Table Header Column Width
    Map<int, pw.TableColumnWidth> widths = Map();
    widths = {
      0: pw.FractionColumnWidth(0.17),
      1: pw.FractionColumnWidth(0.2),
      2: pw.FractionColumnWidth(0.25),
      3: pw.FractionColumnWidth(0.2),
    };
    //^ Constructs the data table
    if (recordList.isNotEmpty) {
      tableList.addAll([
        TextWidget(table.tableNum),
        DataTable(
            recordList: recordList, tableHeader: tableHeader, widths: widths),
        pw.SizedBox(height: 20)
      ]);
    }
    recordList = [];
  });
  return tableList;
}

//? Report Text Headers
class TextWidget extends pw.StatelessWidget {
  String text;
  double fontSize, padding;
  bool header;
  TextWidget(this.text, {this.fontSize = 15, this.header = false});

  @override
  pw.Widget build(pw.Context context) {
    (header) ? padding = 0 : padding = 5;
    return pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Padding(
            padding: pw.EdgeInsets.only(left: padding),
            child: pw.Text(text,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: fontSize))));
  }
}

//? Data Table class
class DataTable extends pw.StatelessWidget {
  List<String> tableHeader;
  List<List<Object>> recordList;
  Map<int, pw.TableColumnWidth> widths;
  DataTable({this.tableHeader, this.recordList, this.widths});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Table.fromTextArray(
      headers: tableHeader,
      data: recordList,
      columnWidths: widths,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.cyan200,
      ),
    );
  }
}
