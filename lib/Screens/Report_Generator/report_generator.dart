import 'package:flutter/material.dart';
import './borrow_report.dart';

class ReportGenerator extends StatefulWidget {
  @override
  _ReportGeneratorState createState() => _ReportGeneratorState();
}

class _ReportGeneratorState extends State<ReportGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Generator"),
        actions: [
          IconButton(
            icon: Icon(Icons.print_rounded),
            onPressed: null,
          )
        ],
      ),
      body: BorrowReport(),
    );
  }
}
