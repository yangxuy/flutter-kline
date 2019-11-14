import 'package:flutter/material.dart';
import 'package:kline/bloc/bloc.dart';
import 'package:kline/bloc/kline-date.dart';

import 'config.dart';
import 'kline-bloc.dart';

class TextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KLineBloc bloc = BlocProvider.of<KLineBloc>(context);
    return StreamBuilder(
      builder: (_, AsyncSnapshot<List<Market>> snapshot) {
        if (snapshot.data != null && snapshot.data.length > 0) {
          return CustomPaint(
            child: Container(),
            painter: TextsPainter(
              bloc: bloc,
            ),
          );
        }
        return Container();
      },
      stream: bloc.klineCurrentListControllerStream,
    );
  }
}

class TextsPainter extends CustomPainter {
  final KLineBloc bloc;

  TextsPainter({this.bloc});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double _priceMin = bloc.priceMin;
    double _priceMax = bloc.priceMax;
    double averagePrice = (_priceMax - _priceMin) / (gridTopRowLength - 1);
    double averageHeight = (size.height - kLineMarginTop) / (gridTopRowLength - 1);
    for (int i = 0; i < gridTopRowLength; i++) {
      double text = i * averagePrice + _priceMin;
      TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: text.toStringAsFixed(6),
            style: TextStyle(
              color: gridTextColor,
              fontSize: gridTextFs,
            ),
          ),
          textDirection: TextDirection.rtl)
        ..layout();
      double dx = size.width - kLineMarginRight - textPainter.size.width;
      double dy = size.height - i * averageHeight - textPainter.size.height;
      textPainter.paint(canvas, Offset(dx, dy));
    }
  }

  @override
  bool shouldRepaint(TextsPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return bloc.priceMin != oldDelegate.bloc.priceMin ||
        bloc.priceMax != oldDelegate.bloc.priceMax;
  }
}
