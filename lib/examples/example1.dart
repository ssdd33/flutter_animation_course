import 'package:flutter/material.dart';
import 'dart:math' show pi;

//Flutter AnimatedBuilder and Transform - Learn the Basics of Animations in Flutter

class RotatingYAxisRectAnimation extends StatefulWidget {
  const RotatingYAxisRectAnimation({super.key});

  @override
  State<RotatingYAxisRectAnimation> createState() =>
      _RotatingYAxisRectAnimationState();
}

class _RotatingYAxisRectAnimationState extends State<RotatingYAxisRectAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
      upperBound: pi * 2,
      lowerBound: 0,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     body: CustomPaint(
      //   painter: MyPainter(),
      // )
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                  origin: const Offset(200, 0),
                  transform: Matrix4.identity()
                    // ..rotateX(_controller.value)
                    // ..rotateZ(_controller.value),
                    ..rotateY(_controller.value),
                  child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3))
                          ]),
                      child: const Text('hellooooo')));
            },
          ),
          const SizedBox(height: 98),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                  angle: pi / 2,
                  child: Container(
                    width: 100,
                    height: 1,
                    color: Colors.blue,
                  ));
            },
          ),
        ],
      )),
    );
  }
}
