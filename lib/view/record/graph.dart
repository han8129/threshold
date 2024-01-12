import 'dart:math';

import 'package:flutter/material.dart';
import 'package:threshold/database/local/records.dart';
import 'package:threshold/model/record.dart';

class MyPainter extends StatefulWidget {
  @override
  State<MyPainter> createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  late Future<List<Record>> records;
  final recordsRepository = RecordsTable();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    records = recordsRepository.getByDates(
        start: DateTime.now().subtract(Duration(days: 3)), end: DateTime.now());
  }

  void _setDates({required DateTime startDate, required DateTime endDate}) {
    setState(() {
      records = recordsRepository.getByDates(start: startDate, end: endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Record>>(
      future: records,
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        final returnedRecords = snapshot.data;

        if (returnedRecords == null || returnedRecords.isEmpty) {
          return const Center(
            child: Text(
              'No records...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          );
        }
        return CustomPaint(
          painter: ShapePainter(records: returnedRecords),
          child: Container(),
        );
      },
    );
  }
}

class ShapePainter extends CustomPainter {
  late final List<Record> records;
  late final double maxY;
  late final double segmentX;

  ShapePainter({required this.records});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height);
    canvas.scale(1, -1);

    final List<Point> points = records
        .map((record) => Point(x: record.date, y: record.durationInSeconds))
        .toList(growable: false);

    maxY = points.map((point) => point.y).reduce(max);


    segmentX = (size.width / points.length);

    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int end = 1; end < points.length; end++) {
      final int start = end - 1;

      final Point startPoint = points[start];
      final Point endPoint = points[end];

      canvas.drawLine(
          Offset(segmentX * start, startPoint.getY / maxY * size.height * 2 / 3),
          Offset(segmentX * end, endPoint.getY / maxY * size.height * 2 / 3),
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class Point {
  final DateTime x;
  final double y;

  const Point({required this.x, required this.y});
  DateTime get getX {
    return x;
  }

  double get getY {
    return y;
  }
}
