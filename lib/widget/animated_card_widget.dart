import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class AnimatedCardWidget extends StatefulWidget {
  @override
  _AnimatedCardWidgetState createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget>
    with TickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();
    const multiplier = 5;

    controller = AnimationController(
      duration: Duration(milliseconds: 500 * multiplier),
      vsync: this,
    );

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 0.55),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 200 * multiplier),
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 90 / 360),
          from: const Duration(milliseconds: 160 * multiplier),
          to: const Duration(milliseconds: 200 * multiplier),
          tag: 'rotate',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0.9, end: 1),
          from: const Duration(milliseconds: 200 * multiplier),
          to: const Duration(milliseconds: 500 * multiplier),
          curve: Curves.elasticOut,
          tag: 'bouncing',
        )
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ScaleTransition(
          scale: sequenceAnimation['scale'],
          child: RotationTransition(
            turns: sequenceAnimation['rotate'],
            child: ScaleTransition(
              scale: sequenceAnimation['bouncing'],
              child: buildCard(onClicked: handleAnimation),
            ),
          ),
        ),
      );

  void handleAnimation() {
    if (controller.isCompleted) {
      controller.reset();
    } else {
      controller.forward();
    }
  }

  Widget buildCard({@required VoidCallback onClicked}) => GestureDetector(
        child: Transform(
          transform: Matrix4.identity()..rotateZ(-pi / 2),
          alignment: Alignment.center,
          child: Image.asset('assets/card.png', fit: BoxFit.fill),
        ),
        onTap: onClicked,
      );
}
