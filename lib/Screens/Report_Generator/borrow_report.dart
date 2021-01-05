import 'package:flutter/material.dart';
import './bar_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BorrowReport extends StatefulWidget {
  @override
  _BorrowReportState createState() => _BorrowReportState();
}

class _BorrowReportState extends State<BorrowReport> {
//! Sample Data
  final List<BarChartModel> data = [
    BarChartModel(
      year: "2014",
      financial: 250,
      barColor: charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
    ),
    BarChartModel(
      year: "2015",
      financial: 300,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    BarChartModel(
      year: "2016",
      financial: 100,
      barColor: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    BarChartModel(
      year: "2017",
      financial: 450,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow),
    ),
    BarChartModel(
      year: "2018",
      financial: 630,
      barColor: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2019",
      financial: 1000,
      barColor: charts.ColorUtil.fromDartColor(Colors.pink),
    ),
    BarChartModel(
      year: "2020",
      financial: 400,
      barColor: charts.ColorUtil.fromDartColor(Colors.purple),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BarChartGraph(data: data);
  }
}
