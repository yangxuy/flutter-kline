import 'package:flutter/material.dart';

///关闭
abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  ///需要修改的child
  final Widget child;

  ///接受的bloc
  final T bloc;

  BlocProvider({
    this.bloc,
    this.child,
  });

  @override
  _BlocProviderState createState() => _BlocProviderState();

  ///获取bloc
  static of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
