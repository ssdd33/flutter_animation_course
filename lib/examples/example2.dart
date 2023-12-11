//Flutter Chained Animations, Curves and Clippers - Learn About Chained Explicit Animations in Flutter

/*
rotating circle composed with semicircles of different 2 color.

1. compose two containers in a row
2. clip out containers with arc
3. animation (1) rotation Z axis with bouncing out
4.
*/

import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide { left, right }

extension PathTo on CircleSide {
  Path toPath(Size size) {
    Path path = Path();
    bool clockwise;
    Offset offset;

    switch (this) {
      case CircleSide.left:
        {
          path.moveTo(size.width, 0);
          offset = Offset(size.width, size.height);
          clockwise = false;
        }
        break;
      case CircleSide.right:
        {
          offset = Offset(0, size.height);
          clockwise = true;
        }
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );

    path.close();
    return path;
  }
}

class ArcClipper extends CustomClipper<Path> {
  final CircleSide side;
  ArcClipper({
    required this.side,
  });

  @override
  getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

class RotatingCircleAnimation extends StatefulWidget {
  const RotatingCircleAnimation({super.key});

  @override
  State<RotatingCircleAnimation> createState() =>
      _RotatingCircleAnimationState();
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class _RotatingCircleAnimationState extends State<RotatingCircleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: -pi / 2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

//causing error: parametic value 1.57... is outside of [0,1] range
    // _controller = AnimationController(
    //     vsync: this,
    //     upperBound: pi / 2,
    //     lowerBound: 0,
    //     duration: const Duration(seconds: 2));
    // _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    _flipAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _flipAnimation = Tween<double>(begin: 0, end: pi / 2).animate(
        CurvedAnimation(
            parent: _flipAnimationController, curve: Curves.bounceOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
                begin: _flipAnimation.value, end: _flipAnimation.value + pi)
            .animate(CurvedAnimation(
                parent: _flipAnimationController, curve: Curves.bounceOut));

        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animation = Tween<double>(
                begin: _animation.value, end: _animation.value + -(pi / 2))
            .animate(
                CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

        _controller
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward.delayed(const Duration(seconds: 1));
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateZ(_animation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                        animation: _flipAnimationController,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..rotateY(_flipAnimation.value),
                            child: ClipPath(
                              clipper: ArcClipper(side: CircleSide.left),
                              child: Container(
                                width: 100,
                                height: 100,
                                color: const Color(0xff0057b7),
                              ),
                            ),
                          );
                        }),
                    AnimatedBuilder(
                        animation: _flipAnimationController,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..rotateY(_flipAnimation.value),
                            child: ClipPath(
                              clipper: ArcClipper(side: CircleSide.right),
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.yellow,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
