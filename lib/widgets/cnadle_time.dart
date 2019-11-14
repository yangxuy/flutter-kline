import 'package:flutter/material.dart';
import 'package:kline/bloc/bloc.dart';
import 'package:kline/bloc/kline-date.dart';

import 'config.dart';
import 'kline-bloc.dart';

class CandleTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KLineBloc bloc = BlocProvider.of<KLineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineCurrentListControllerStream,
      builder: (_, AsyncSnapshot<List<Market>> snapshot) {
        if (snapshot.data != null && snapshot.data.length > 0) {
          return CustomPaint(
            painter: TimePainter(bloc: bloc),
            child: Container(),
          );
        }
        return Container();
      },
    );
  }
}

class TimePainter extends CustomPainter {
  final KLineBloc bloc;

  TimePainter({@required this.bloc});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double averageGap =
        (size.width - kLineMarginRight - kLineMarginLeft) / (gridColumnLength-1);

    List<Market> currentMarket = bloc.klineCurrentDataList;

    for (int i = 0; i < gridColumnLength; i++) {
      int index = (i * averageGap + kLineMarginLeft) ~/
          (bloc.klineCandleWidth + kLineCandleGap);
      if (index < currentMarket.length) {
        int timeStamp = currentMarket[i].id;
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
        int month = dateTime.month;
        int day = dateTime.day;
        int hour = dateTime.hour;
        int minute = dateTime.minute;
        String time = '$month-$day $hour:$minute';
        TextPainter textPainter=TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: time,
            style: TextStyle(
              color: gridTextColor,
              fontSize: gridTextFs
            )
          )
        )..layout();
        double dx=i * averageGap + kLineMarginLeft-textPainter.size.width/2;
        double dy=0;
        Offset offset=Offset(dx, dy);
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(TimePainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.bloc.klineCurrentDataList!=bloc.klineCurrentDataList;
  }
}
