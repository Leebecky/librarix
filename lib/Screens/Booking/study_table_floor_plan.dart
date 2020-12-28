import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import '../../Models/study_table.dart';

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
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: Text("Entrance to Quiet Zone")),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                //TODO consider sizing for other phones. Remove border once done with this
                height: MediaQuery.of(context).size.height - 150,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<StudyTable>>(
                    //~ Painter for the Floor Plan
                    future: studyTableList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<StudyTable>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
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
                                          availableTables:
                                              widget.tablesAvailable,
                                          changeSelection: changeSelection,
                                          selectedTable: selectedTable,
                                        ),
                                      ),
                                    ));
                                  });
                            });
                      }
                      return SpinKitWave(color: Theme.of(context).accentColor);
                    }),
              ),
              confirmationButtons(context,
                  checkButtonClicked: () => {
                        widget.selectedStudyTable.value =
                            selectedTable.value[0],
                      })
            ]),
          ),
        ));
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
  final List<String> availableTables;
  ValueNotifier<List<String>> selectedTable;
  String selection;
  ValueNotifier<bool> changeSelection;

  PathPainter(
    this.context, {
    this.availableTables,
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

      paintTables.color = Colors.white;
      if (!availableTables.contains(table.tableNum)) {
        //^ Tables that have been booked
        paintTables.color = Colors.red;
        paintTables.style = PaintingStyle.fill;
      }
      //^ Available Tables
      if (availableTables.contains(table.tableNum)) {
        paintTables.color = Colors.white;
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
          /*   if (selectedTable.value.contains(table.tableNum)) {
            selectedTable.value.remove(table.tableNum);
          } */
          /*  if (selectedTable.value
              .contains(!availableTables.contains(table.tableNum))) {
            selectedTable.value.remove(table.tableNum);
          } */
        },
      );
    });
  }

//? Method that triggers repainting of the canvas
  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;
  // changeSelection.value == oldDelegate.changeSelection.value;
}
