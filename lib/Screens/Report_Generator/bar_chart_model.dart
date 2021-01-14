import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:random_color/random_color.dart';
import 'package:librarix/config.dart';

//? Class which defines the properties used in the chart
class BarChartModel {
  String xAxis;
  int yAxis;
  charts.Color barColor;
  BarChartModel({this.yAxis, this.xAxis, this.barColor});

  static Color generateRandomColor() {
    return (currentTheme.currentTheme() == ThemeMode.light)
        ? RandomColor().randomColor(colorBrightness: ColorBrightness.dark)
        : RandomColor().randomColor(colorBrightness: ColorBrightness.light);
  }
}

//? Widget for generating displaying the chart
class BarChartGraph extends StatefulWidget {
  final List<BarChartModel> data;
  final String chartHeading, xHeading;
  const BarChartGraph({Key key, this.data, this.chartHeading, this.xHeading})
      : super(key: key);

  @override
  _BarChartGraphState createState() => _BarChartGraphState();
}

class _BarChartGraphState extends State<BarChartGraph> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "Bar_Charts",
        data: widget.data,
        domainFn: (BarChartModel series, _) => series.xAxis,
        measureFn: (BarChartModel series, _) => series.yAxis,
        colorFn: (BarChartModel series, _) => series.barColor,
      ),
    ];

    return _buildBarChart(series,
        chartHeading: widget.chartHeading, xHeading: widget.xHeading);
  }

  Widget _buildBarChart(series, {String chartHeading, String xHeading}) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          //~ Heading
          Text(
            chartHeading,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ), //~ Barchart
          Expanded(
              child: charts.BarChart(
            series,
            animate: true,
            behaviors: [
              charts.LinePointHighlighter(
                  symbolRenderer: CustomCircleSymbolRenderer())
            ],
            selectionModels: [
              charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection) {
                  final value = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index);
                  CustomCircleSymbolRenderer.value =
                      value.toString(); // paints the tapped value
                }
              })
            ],
            //Sets the colours of the azes
            primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.gray.shade500),
                    lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.gray.shade500))),
            domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.gray.shade500),
                    lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.gray.shade500))),
          )),
          Text(xHeading,
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

//? ToolTip display
class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static String value;
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      charts.FillPatternType fillPattern,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        strokeColor: charts.Color.black,
        strokeWidthPx: 1);

    // Draw a bubble

    final num bubbleHight = 40;
    final num bubbleWidth = 120;
    final num bubbleRadius = bubbleHight / 2.0;
    final num bubbleBoundLeft = bounds.left;
    final num bubbleBoundTop = bounds.top - bubbleHight;

    canvas.drawRRect(
      Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHight),
      fill: charts.Color.black,
      stroke: charts.Color.black,
      radius: bubbleRadius,
      roundTopLeft: true,
      roundBottomLeft: true,
      roundBottomRight: true,
      roundTopRight: true,
    );

    // Add text inside the bubble
    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    final chartsTextElement.TextElement textElement =
        chartsTextElement.TextElement(value, style: textStyle);

    final num textElementBoundsLeft = ((bounds.left +
            (bubbleWidth - textElement.measurement.horizontalSliceWidth) / 2))
        .round();
    final num textElementBoundsTop = (bounds.top - 30).round();

    canvas.drawText(textElement, textElementBoundsLeft, textElementBoundsTop);
  }
}
