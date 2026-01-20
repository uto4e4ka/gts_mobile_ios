import 'package:flutter/material.dart';

class BarLegend extends StatelessWidget {
  final Color color;
  final String text;
  final double textSize;
  final double height;

  const BarLegend({
    super.key,
    required this.color,
    required this.text,
    this.textSize = 14,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarLegendPainter(
        color: color,
        text: text,
        textSize: textSize,
        textColor: Theme.of(context).colorScheme.onSurface,
      ),
      size: Size(_calculateWidth(context), height),
    );
  }

  double _calculateWidth(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: textSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return 50 + textPainter.width + 8;
  }
}

class _BarLegendPainter extends CustomPainter {
  final Color color;
  final String text;
  final double textSize;
  final Color textColor;

  _BarLegendPainter({
    required this.color,
    required this.text,
    required this.textSize,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    /// Цветной прямоугольник (50px)
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, 20, size.height),
      const Radius.circular(5),
    );

    canvas.drawRRect(rect, paint);

    /// Текст
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: textSize, color: textColor),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(25, size.height / 2 - textPainter.height / 2);

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _BarLegendPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.text != text ||
        oldDelegate.textSize != textSize;
  }
}
