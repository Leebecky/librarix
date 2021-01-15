import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import './borrow_report.dart';
import './booking_report.dart';
import './fines_report.dart';
import 'pdf_report_generator.dart';

class ReportGenerator extends StatefulWidget {
  @override
  _ReportGeneratorState createState() => _ReportGeneratorState();
}

class _ReportGeneratorState extends State<ReportGenerator>
    with SingleTickerProviderStateMixin {
  TabController reportTabs;
  int currentTab;
  @override
  void initState() {
    reportTabs = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          currentTab = reportTabs.index;
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
              IconButton(
                  icon: Icon(Icons.print_rounded),
                  onPressed: () => generatePdfReport(
                      context, PdfPageFormat.a4, reportTabs.index))
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
}
