import 'package:flutter/material.dart';
import 'package:kline/bloc/bloc.dart';
import 'package:kline/bloc/kline-date.dart';

import 'config.dart';
import 'kline-bloc.dart';

class CandleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KLineBloc bloc = BlocProvider.of<KLineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineCurrentListControllerStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        if (snapshot.data != null && snapshot.data.length > 0) {
          return CustomPaint(
            child: Container(),
            painter: CandlerPainter(bloc: bloc),
          );
        }
        return Container();
      },
    );
  }
}

class CandlerPainter extends CustomPainter {
  final KLineBloc bloc;
  Paint increasePaint;
  Paint decreasePaint;

  CandlerPainter({this.bloc})
      : increasePaint = Paint()
          ..color = kLineCandleIncreaseColor
          ..strokeWidth = kLineCandleLineWidth,
        decreasePaint = Paint()
          ..color = kLineCandleDecreaseColor
          ..strokeWidth = kLineCandleLineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    List<Market> marketList = bloc.klineCurrentDataList;
    double height = size.height - kLineMarginTop;
    double average = height / (bloc.priceMax - bloc.priceMin);
    for (int i = 0; i < marketList.length; i++) {
      double left = i * (kLineCandleGap + bloc.klineCandleWidth) -
          kLineCandleLineWidth / 2;
      double top = height -
          average * (marketList[i].close - bloc.priceMin) +
          kLineMarginTop;
      double right = left + bloc.klineCandleWidth - kLineCandleLineWidth / 2;
      double bottom = height -
          average * (marketList[i].open - bloc.priceMin) +
          kLineMarginTop;

      Rect rect = Rect.fromLTRB(left, top, right, bottom);
      double dx = left + bloc.klineCandleWidth / 2;
      double dh = height -
          (marketList[i].high - bloc.priceMin) * average +
          kLineMarginTop;
      double dl = height -
          (marketList[i].low - bloc.priceMin) * average +
          kLineMarginTop;
      Offset p1 = Offset(dx, top);
      Offset p2 = Offset(dx, dh);
      Offset p3 = Offset(dx, bottom);
      Offset p4 = Offset(dx, dl);
      if (marketList[i].close > marketList[i].open) {
        canvas.drawRect(rect, increasePaint);
        canvas.drawLine(p1, p2, increasePaint);
        canvas.drawLine(p3, p4, increasePaint);
      } else {
        canvas.drawRect(rect, decreasePaint);
        canvas.drawLine(p1, p2, decreasePaint);
        canvas.drawLine(p3, p4, decreasePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CandlerPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.bloc.priceMin != oldDelegate.bloc.priceMin ||
        oldDelegate.bloc.priceMax != oldDelegate.bloc.priceMax ||
        oldDelegate.bloc.klineCurrentDataList !=
            oldDelegate.bloc.klineCurrentDataList;
  }
}
