import 'dart:async';

import 'package:flutter/material.dart';

class Normal extends StatefulWidget {
  @override
  _NormalState createState() => _NormalState();
}

class _NormalState extends State<Normal> {
  double fs = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '普通数据驱动',
          style: TextStyle(fontSize: fs, color: Colors.orange),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            fs++;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class StreamDome extends StatelessWidget {
  double fs = 16.0;

  @override
  Widget build(BuildContext context) {
    StreamController<double> controller = StreamController.broadcast();
    controller.stream.listen((v){
      print(v);
    });
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          builder: (context, AsyncSnapshot<double> snapshot) {
            return Text(
              '普通数据驱动',
              style: TextStyle(fontSize: snapshot.data, color: Colors.black),
            );
          },
          stream: controller.stream,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fs++;
          controller.sink.add(fs);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
