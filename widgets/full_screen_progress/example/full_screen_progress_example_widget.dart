import '../dark_loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullScreenProgressExampleWidget extends StatelessWidget {

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
                child: Text("Full Screen Progress"),
                onPressed: () => _showProgress(context),
                color: Colors.blue,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showProgress(BuildContext context) async {
    var progress = DarkLoadingProgress(context);
    progress.show();
    await Future.delayed(Duration(seconds: 4));
    progress.dismiss();
  }
}
