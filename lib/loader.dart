import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;

  final double initialradius = 30.0;
  double radius = 3.0;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animationRadiusIn = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));

    animationRadiusOut = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialradius;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animationRadiusOut.value * initialradius;
        }
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: new Center(
          child: new RotationTransition(
        turns: animationRotation,
        child: new Container(
          child: new Center(
            child: Stack(
              children: <Widget>[
                Dot(
                  radius: 30.0,
                  color: Colors.grey,
                ),
                new Transform.translate(
                  offset: Offset(0.0, 0.0),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.redAccent,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.greenAccent,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.blueAccent,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.amberAccent,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.blue,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.orangeAccent,
                  ),
                ),
                new Transform.translate(
                  offset:
                      Offset(radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                  child: Dot(
                    radius: 5.0,
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

