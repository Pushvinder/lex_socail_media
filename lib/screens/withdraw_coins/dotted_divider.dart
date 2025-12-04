import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double gap;

  const DottedLine({
    this.color = Colors.black,
    this.height = 1,
    this.gap = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedLinePainter(color, height, gap),
      size: Size(double.infinity, height),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double height;
  final double gap;

  _DottedLinePainter(this.color, this.height, this.gap);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = height
      ..style = PaintingStyle.stroke;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + gap, 0), paint);
      startX += gap * 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
