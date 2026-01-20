import 'package:flutter/material.dart';

class HorizontalSegmentsBar extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;

  const HorizontalSegmentsBar({
    super.key,
    required this.values,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: CustomPaint(
        painter: _SegmentsPainter(values, colors),
        size: const Size(double.infinity, 14),
      ),
    );
  }
}

class _SegmentsPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _SegmentsPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (a, b) => a + b);
    double startX = 0;

    for (var i = 0; i < values.length; i++) {
      final paint = Paint()..color = colors[i];
      final width = size.width * (values[i] / total);

      // Rounded left and right only
      final radius = Radius.circular(8);

      RRect rrect;

      if (i == 0) {
        // first segment
        rrect = RRect.fromRectAndCorners(
          Rect.fromLTWH(startX, 0, width, size.height),
          topLeft: radius,
          bottomLeft: radius,
        );
      } else if (i == values.length - 1) {
        // last segment
        rrect = RRect.fromRectAndCorners(
          Rect.fromLTWH(startX, 0, width, size.height),
          topRight: radius,
          bottomRight: radius,
        );
      } else {
        // middle
        rrect = RRect.fromLTRBR(
          startX,
          0,
          startX + width,
          size.height,
          Radius.zero,
        );
      }

      canvas.drawRRect(rrect, paint);

      startX += width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
