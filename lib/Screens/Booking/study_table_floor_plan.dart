import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:librarix/Custom_Widget/general_alert_dialog.dart';
import 'package:librarix/config.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import '../../Models/study_table.dart';
//TODO check floor plan sizing

class FloorPlan extends StatefulWidget {
  final List<String> tablesAvailable;
  final ValueNotifier<String> selectedStudyTable;
  FloorPlan({this.tablesAvailable, this.selectedStudyTable});

  @override
  _FloorPlanState createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> {
  List<StudyTable> tableList = [];
  ValueNotifier<bool> changeSelection;
  ValueNotifier<List<String>> selectedTable;

  @override
  void initState() {
    selectedTable =
        ValueNotifier<List<String>>([widget.selectedStudyTable.value]);
    changeSelection = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quiet Zone Floor Plan"),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Stack(
                children: [
                  Positioned(
                    right: 0,
                    child: Container(
                        padding: EdgeInsets.only(right: 20, left: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Text(
                          "Entrance to Quiet Zone",
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                  Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Column(children: [
                            floorPlanLegend(
                                legendColor: (currentTheme.currentTheme() ==
                                        ThemeMode.light)
                                    ? Colors.black
                                    : Colors.white,
                                legendText: "Available"),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: floorPlanLegend(
                                  legendColor: Colors.red,
                                  legendText: "Booked"),
                            ),
                            floorPlanLegend(
                                legendColor: Theme.of(context).accentColor,
                                legendText: "Selected"),
                          ]))),
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<List<StudyTable>>(
                        //~ Painter for the Floor Plan
                        future: studyTableList(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<StudyTable>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ValueListenableBuilder<List<String>>(
                                valueListenable: selectedTable,
                                builder: (BuildContext context,
                                    List<String> tableSelected, Widget child) {
                                  return ValueListenableBuilder<bool>(
                                      valueListenable: changeSelection,
                                      builder: (BuildContext context,
                                          bool selectionChanged, Widget child) {
                                        return Container(
                                            child: CanvasTouchDetector(
                                          builder: (context) => CustomPaint(
                                            painter: PathPainter(
                                              context,
                                              tableList: snapshot.data,
                                              bookedTables:
                                                  widget.tablesAvailable,
                                              changeSelection: changeSelection,
                                              selectedTable: selectedTable,
                                            ),
                                          ),
                                        ));
                                      });
                                });
                          }
                          return SpinKitWave(
                              color: Theme.of(context).accentColor);
                        }),
                  ),
                ],
              ),
              confirmationButtons(context,
                  checkButtonClicked: () => {
                        if (selectedTable.value.isNotEmpty)
                          {
                            widget.selectedStudyTable.value =
                                selectedTable.value[0],
                            Navigator.of(context).pop(),
                          }
                        else
                          {
                            generalAlertDialog(context,
                                title: "Invalid Selection",
                                content: "Please select an available table!")
                          }
                      })
            ]),
          ),
        ));
  }

  //? Floor Plan Legend
  Widget floorPlanLegend({String legendText, Color legendColor}) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(color: legendColor),
        ),
        Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              legendText,
            )),
      ],
    );
  }

//? Retrieves the study tables from the database
  Future<List<StudyTable>> studyTableList() async {
    tableList = await getStudyTables();
    return tableList;
  }
}

class PathPainter extends CustomPainter {
  final BuildContext context;
  final List<StudyTable> tableList;
  final List<String> bookedTables;
  ValueNotifier<List<String>> selectedTable;
  ValueNotifier<bool> changeSelection;
  String selection;

  PathPainter(
    this.context, {
    this.bookedTables,
    this.tableList,
    this.changeSelection,
    this.selectedTable,
  }) : super(repaint: selectedTable);

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);

//^ The paint object (sets the style and stroke width)
    Paint paintTables = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    //^ Scale each path to match canvas size
    var xScale = size.width / 190;
    var yScale = size.height / 230;
    final Matrix4 matrix4 = Matrix4.identity();

    matrix4.scale(xScale, yScale);

//? Loops through the list of tables and paints the path of each table
    tableList.forEach((table) {
      Path path = parseSvgPathData(table.svgPath);

      if (bookedTables.contains(table.tableNum)) {
        //^ Tables that have been booked
        paintTables.color = Colors.red;
        paintTables.style = PaintingStyle.fill;
      }
      //^ Available Tables
      if (!bookedTables.contains(table.tableNum)) {
        //~ Checks the current theme and sets the paint color accordingly
        (currentTheme.currentTheme() == ThemeMode.light)
            ? paintTables.color = Colors.black
            : paintTables.color = Colors.white;
        paintTables.style = PaintingStyle.stroke;
      }

      //^ Selected Table
      if (selectedTable.value.contains(table.tableNum)) {
        paintTables.color = Theme.of(context).accentColor;
        paintTables.style = PaintingStyle.fill;
      }

      path.transform(matrix4.storage);

      myCanvas.drawPath(
        path.transform(matrix4.storage),
        paintTables,
        onTapDown: (details) {
          selectedTable.value.add(table.tableNum);
          changeSelection.value = !changeSelection.value;
          if (selectedTable.value.length > 1) {
            selectedTable.value.removeAt(0);
          }
          for (var bookedTable in bookedTables) {
            if (selectedTable.value.contains(bookedTable)) {
              selectedTable.value.remove(bookedTable);
            }
          }
        },
      );
    });
  }

//? Method that triggers repainting of the canvas
  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;
}
