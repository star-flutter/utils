import 'dart:async';
import '../progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressButonExampleWidget extends StatefulWidget {

  @override
  ProgressButonExampleWidgetState createState() => ProgressButonExampleWidgetState();
}

class ProgressButonExampleWidgetState extends State<ProgressButonExampleWidget> {

  StreamController buttonController = StreamController<ProgressButtonStates>.broadcast();
  Sink get buttonSink => buttonController.sink;
  Stream<ProgressButtonStates> get buttonStream => buttonController.stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProgressButton(
                title: "Click Me",
                onClick: () => _onButtonClick(),
                stream: buttonStream,
                isEnabled: true,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onButtonClick() async {
    buttonSink.add(ProgressState());
    await Future.delayed(Duration(seconds: 4));
    buttonSink.add(ActionSucceed());
    await Future.delayed(Duration(seconds: 2));
    buttonSink.add(ActionFailed()); //reset to original state
  }

  @override
  void dispose() {
    buttonController.close();
    super.dispose();
  }
}
