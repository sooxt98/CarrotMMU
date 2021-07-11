import 'package:carrotmmu/widget/fader.dart';
import 'package:flutter/material.dart';

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    Key key,
    this.index,
    this.children,
    this.duration = const Duration(
      milliseconds: 600,
    ),
  }) : super(key: key);

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation1;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.2);
      _controller1.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller1 = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
    _animation1 = CurvedAnimation(parent: _controller1, curve: Curves.ease);
    _controller.forward();
    _controller1.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_controller.value);
    // return Fader(
    //   // opacity: _controller,
    //   child: IndexedStack(
    //     index: widget.index,
    //     children: widget.children,
    //   ),
    // );

    return ScaleTransition(
      scale: _animation,
          child: FadeTransition(
        opacity: _animation1,
        child: IndexedStack(
          index: widget.index,
          children: widget.children,
        ),
      ),
    );
  }
}