import '../toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToastExampleWidget extends StatelessWidget {

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
              MaterialButton(
                child: Text("Toast"),
                onPressed: () => Toast.show("This is a sample Toast message", context),
                color: Colors.blue,
              )
            ],
          ),
        ],
      ),
    );
  }
}
