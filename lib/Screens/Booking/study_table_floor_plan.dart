import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart';
import '../../Models/study_table.dart';

class FloorPlan extends StatefulWidget {
  @override
  _FloorPlanState createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> {
  List<String> tableNum = [];
  List<StudyTable> tableList = [];
  ValueNotifier<String> selection;

  @override
  void initState() {
    selection = ValueNotifier<String>("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<StudyTable>>(
            future: studyTableList(),
            builder: (BuildContext context,
                AsyncSnapshot<List<StudyTable>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ValueListenableBuilder<String>(
                    valueListenable: selection,
                    builder:
                        (BuildContext context, String value, Widget child) {
                      return Container(
                          child: CanvasTouchDetector(
                        builder: (context) => CustomPaint(
                          painter: PathPainter(context,
                              tableList: snapshot.data, a: selection),
                        ),
                      ));
                    });
              }
              return SpinKitWave(color: Theme.of(context).accentColor);
            }));
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
  List<String> selectedTable = [];
  ValueNotifier<String> a;

  PathPainter(
    this.context, {
    this.tableList,
    this.a,
  }) : super(repaint: a);

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);
    // ValueNotifier<String> selection = ValueNotifier<String>(selectedTable);

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Scale each path to match canvas size
    var xScale = size.width / 190;
    var yScale = size.height / 230;
    final Matrix4 matrix4 = Matrix4.identity();

    matrix4.scale(xScale, yScale);

    tableList.forEach((table) {
      Path path = parseSvgPathData(table.svgPath);

      paint.color = Colors.white;

      if (selectedTable.contains(table.tableNum)) {
        paint.color = Colors.red;
        print("Hit");
      }

      path.transform(matrix4.storage);

      myCanvas.drawPath(
        path.transform(matrix4.storage),
        paint,
        onTapDown: (details) {
          /*    selectedTable.add(table.tableNum);
          if (selectedTable.length > 1) {
            selectedTable.removeAt(0);
          } */
          if (!selectedTable.contains(table.tableNum)) {
            selectedTable.add(table.tableNum);
            a.value = table.tableNum;
          }
          /* else {
            selectedTable.remove(table.tableNum);
          }
          if (selectedTable.length > 1) {
            selectedTable.removeAt(0);
          } */
          print("${table.tableNum}");
        },
      );
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
