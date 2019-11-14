import 'package:flutter/material.dart';
import 'config.dart';

class GridWidget extends StatelessWidget {
  final bool isTop;

  GridWidget({this.isTop = true});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: GridWidgetPainter(isTop),
    );
  }
}

class GridWidgetPainter extends CustomPainter {
  final bool isTop;
  Paint gridPaint;

  GridWidgetPainter(this.isTop) {
    gridPaint = Paint()
      ..color = gridLineColor
      ..strokeWidth = gridLineWidth
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    int gridRowLength = isTop ? gridTopRowLength : gridBottomRowLength;
    double kMarginTop = isTop ? kLineMarginTop : 0.0;
    double height = size.height - kMarginTop;
    double width = size.width - kLineMarginLeft - kLineMarginRight;
    double lineRowGap = height / (gridRowLength - 1);
    double lineColumnGap = width / (gridColumnLength - 1);

    for (int i = 0; i < gridRowLength; i++) {
      double dy = size.height - lineRowGap * i;
      Offset p1 = Offset(kLineMarginLeft, dy);
      Offset p2 = Offset(size.width - kLineMarginRight, dy);
      canvas.drawLine(p1, p2, gridPaint);
    }
    for (int i = 0; i < gridColumnLength; i++) {
      double dx = kLineMarginLeft + i * lineColumnGap;
      Offset p1 = Offset(dx, size.height);
      Offset p2 = Offset(dx, kMarginTop);
      canvas.drawLine(p1, p2, gridPaint);
    }
  }

  @override
  bool shouldRepaint(GridWidgetPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
