import 'package:flutter/material.dart';
import 'package:kline/bloc/bloc.dart';
import 'package:kline/bloc/kline-date.dart';

import 'config.dart';
import 'kline-bloc.dart';

class VolWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KLineBloc bloc = BlocProvider.of<KLineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineCurrentListControllerStream,
      builder: (_, AsyncSnapshot<List<Market>> snapshot) {
        if (snapshot.data != null && snapshot.data.length > 0) {
          return CustomPaint(
            child: Container(),
            painter: VolPainter(
              bloc: bloc,
            ),
          );
        }
        return Container();
      },
    );
  }
}

class VolPainter extends CustomPainter {
  final KLineBloc bloc;
  Paint increasePaint;
  Paint decreasePaint;

  VolPainter({this.bloc})
      : increasePaint = Paint()
          ..color = kLineCandleIncreaseColor
          ..strokeWidth = kLineCandleLineWidth,
        decreasePaint = Paint()
          ..color = kLineCandleDecreaseColor
          ..strokeWidth = kLineCandleLineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    List<Market> currentList = bloc.klineCurrentDataList;
    // TODO: implement paint
    double average = size.height / bloc.volMax;
    for (int i = 0; i < currentList.length; i++) {
      double left =
          i * (kLineCandlerWidth + kLineCandleGap) - kLineCandleLineWidth / 2;
      double top = size.height - average * currentList[i].vol;
      double right = left + kLineCandlerWidth - kLineCandleLineWidth / 2;
      Rect rect = Rect.fromLTRB(left, top, right, size.height);
      Paint paint = currentList[i].close > currentList[i].open
          ? increasePaint
          : decreasePaint;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(VolPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.bloc.klineCurrentDataList != bloc.klineCurrentDataList;
  }
}
