import 'package:flutter/material.dart';
import 'dart:math';

class Arc extends CustomPainter {
  double angle = 210.0;
  double doubleToAngle(double angle) => angle * pi / 180.0;

  Arc(this.angle);

static double convertRadiusToSigma(double radius) {
        return radius * 0.57735 + 0.5;
    }

  void drawArcWithRadius(
      Canvas canvas, Offset center, double radius, double angle, Paint paint) {
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        doubleToAngle(-90.0), doubleToAngle(angle), false, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);
    final Offset shadowCenter = Offset(size.width / 2.0, size.height / 2.0 * 1.02);
    final double radius = size.width / 2.6;
    final double lerp = 1 - (1 - ((1 - (this.angle / 360)) / 0.25)).clamp(0.0, 1.0);
    // print("Size $size");
    // print("Width ${size.width}");
    // print("Size $center");
    // print("Size $radius");
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      // ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..color = Colors.red
     
      ..shader = LinearGradient(
        begin: Alignment(-1.0, -2.0),
          end: Alignment(1.0, 2.0),
        // startAngle: 2.9 * pi / 2,
        // endAngle: 7 * pi / 2,
        // tileMode: TileMode.clamp,
        colors: [Color.lerp(Colors.green, Colors.red, lerp), Color.lerp(Colors.lightGreen.shade400, Colors.amber, lerp)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    drawArcWithRadius(canvas, center, radius, angle, paint);
    drawArcWithRadius(canvas, shadowCenter, radius, angle, paint..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(15)));

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
