import 'package:flutter/material.dart';
import 'package:kline/widgets/TextWidget.dart';
import 'package:kline/widgets/candle_widget.dart';
import 'package:kline/widgets/cnadle_time.dart';
import 'package:kline/widgets/config.dart';
import 'package:kline/widgets/grid_widget.dart';
import 'package:kline/widgets/kline-bloc.dart';
import 'package:kline/widgets/vol_widget.dart';

import 'bloc/bloc.dart';
import 'bloc/kline-date.dart';

void main() => runApp(MyApp());

///bloc数据流动 stream-->流
///setState StatefulWidget
///stream StreamBuild
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Kline(),
    );
  }
}

// todo:分析流程
// 采用的布局是成叠布局
class Kline extends StatefulWidget {
  @override
  _KlineState createState() => _KlineState();
}

class _KlineState extends State<Kline> {
  KLineBloc _bloc;

  @override
  void initState() {
    _bloc = KLineBloc();
    List<Market> list = [];

    ///http或者socket
    for (int i = 0; i < testData.length; i++) {
      list.add(
        Market(
          testData[i]['open'],
          testData[i]['high'],
          testData[i]['low'],
          testData[i]['close'],
          testData[i]['vol'],
          testData[i]['id'],
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((v) {
      _bloc.handlerSetKlineSize(context.size.width);
      _bloc.handlerUpdateData(list);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: kLineBgColor,
          width: MediaQuery.of(context).size.width,
          height: 400.0,
          child: BlocProvider<KLineBloc>(
            bloc: _bloc,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Stack(
                        children: <Widget>[
                          GridWidget(),
                          TextWidget(),
                          CandleWidget(),
                        ],
                      ),
                    ),

                    ///时间
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: CandleTime(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: <Widget>[
                          GridWidget(isTop: false),
                          VolWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
