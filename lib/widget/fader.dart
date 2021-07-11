import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// Create enum that defines the animated properties
enum AniProps { width, height, color }

class Fader extends StatelessWidget {
  final Widget child;

  Fader({this.child});

  // Specify your tween
  

  @override
  Widget build(BuildContext context) {

    var _tween = new MultiTween<AniProps>()
    ..add(AniProps.width, 0.0.tweenTo(100.0), 1000.milliseconds)
    ..add(AniProps.width, 100.0.tweenTo(200.0), 500.milliseconds)
    ..add(AniProps.height, 0.0.tweenTo(200.0), 2500.milliseconds)
    ..add(AniProps.color, Colors.red.tweenTo(Colors.blue), 3.seconds);


    return new PlayAnimation<MultiTweenValues<AniProps>>(
      key: UniqueKey(),
      tween: _tween, // Pass in tween
      duration: _tween.duration, // Obtain duration from MultiTween
      builder: (context, child, value) {
        return Container(
          child: this.child,
          width: value.get(AniProps.width), // Get animated value for width
          height: value.get(AniProps.height), // Get animated value for height
          color: value.get(AniProps.color), // Get animated value for color
        );
      },
    );
  }
}
