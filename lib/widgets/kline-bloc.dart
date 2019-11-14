import 'dart:async';
import 'dart:math';
import 'package:kline/bloc/bloc.dart';
import 'package:kline/bloc/kline-date.dart';
import 'config.dart';

class KLineBloc extends BlocBase {
  StreamController<List<Market>> klineTotalListController =
      StreamController<List<Market>>.broadcast();

  Sink<List<Market>> get klineTotalListControllerSink =>
      klineTotalListController.sink;

  Stream<List<Market>> get klineTotalListControllerStream =>
      klineTotalListController.stream;

  StreamController<List<Market>> klineCurrentListController =
      StreamController<List<Market>>.broadcast();

  Sink<List<Market>> get klineCurrentListControllerSink =>
      klineCurrentListController.sink;

  Stream<List<Market>> get klineCurrentListControllerStream =>
      klineCurrentListController.stream;

  ///总数据
  List<Market> klineTotalDataList = [];

  ///当前显示的数据
  List<Market> klineCurrentDataList = [];

  ///画布大小
  double klineSize;
  int screenCandleCount = 0;
  int firstScreenCandleCount = 0;

  ///烛台的宽度---》缩放时改变
  double klineCandleWidth = kLineCandlerWidth;
  int formIndex = 0;
  int toIndex = 0;

  ///当前最低最高价
  double priceMax;
  double priceMin;

  ///当前交易量
  double volMax;

  @override
  void dispose() {
    klineCurrentListController.close();
    klineTotalListController.close();
  }

  ///设置展示
  handlerSetKlineSize(double size) {
    klineSize = size;
    screenCandleCount =
        ((size + kLineCandleGap) ~/ (klineCandleWidth + kLineCandleGap));
  }

  ///发送数据
  handlerUpdateData(List<Market> list) {
    klineTotalDataList = list;
    klineTotalListControllerSink.add(list);
    handlerFirstShow();
    handlerSendCurrentKlineList();
  }

  ///设置首屏显示
  handlerFirstShow() {
    firstScreenCandleCount =
        (screenCandleCount * (1 - 1 / gridColumnLength)).toInt();
    int maxCount = this.klineTotalDataList.length;
    if (maxCount < firstScreenCandleCount) {
      firstScreenCandleCount = maxCount;
    }
  }

  ///计算from to
  handlerKlineCurrentDataFromAndTo() {
    toIndex = klineTotalDataList.length;
    formIndex = toIndex - firstScreenCandleCount;
    if (formIndex <= 0) {
      formIndex = 0;
    }
  }

  ///发送当前k线展示的值
  handlerSendCurrentKlineList() {
    handlerKlineCurrentDataFromAndTo();
    print('fromindex: $formIndex' +
        'toindex:$toIndex totalData: ${klineTotalDataList.length} screenCandleCount: $screenCandleCount');
    klineCurrentDataList.clear();
    klineCurrentDataList = klineTotalDataList.sublist(formIndex, toIndex);
    calculateCurrentKlineDataLimit();
    klineCurrentListControllerSink.add(klineCurrentDataList);
  }

  ///计算最大最小值
  calculateCurrentKlineDataLimit() {
    double _priceMax = -double.infinity;
    double _priceMin = double.infinity;
    double _volMax = -double.infinity;
    for (Market item in klineCurrentDataList) {
      _priceMax = max(item.high.toDouble(), _priceMax);
      _priceMin = min(item.low.toDouble(), _priceMin);
      _volMax = max(item.vol, _volMax);
    }
    priceMax = _priceMax;
    priceMin = _priceMin;
    volMax = _volMax;
  }
}
