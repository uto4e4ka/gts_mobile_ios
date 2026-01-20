import 'package:flutter/material.dart';
import 'package:gts_mobile/bar.dart';

class AdviseCard extends StatelessWidget {
  final List<double> segments;
  final List<Color> colors;

  const AdviseCard({super.key, required this.segments, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ----- Left image -----
          SizedBox(
            width: 120,
            height: 120,
            child: Image.asset("assets/work_history.png", fit: BoxFit.contain),
          ),

          const SizedBox(width: 16),

          // ----- Right content -----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fee earned
                const Text(
                  "Fee earned",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                // Fee today
                const Text("Fee today", style: TextStyle(fontSize: 16)),

                const SizedBox(height: 10),

                // Segmented bar
                HorizontalSegmentsBar(values: segments, colors: colors),

                const SizedBox(height: 15),

                // Button aligned right
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                    ),
                    child: const Text(
                      "Details",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
