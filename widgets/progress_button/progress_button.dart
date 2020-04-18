import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../extensions/dp_converter/ui_extensions.dart';

class ProgressButton extends StatefulWidget {
  ProgressButton({
    Key key,
    this.title,
    this.onClick,
    this.stream,
    this.isEnabled = false,
    this.backgroundColor = Colors.black
  }) : super(key: key);

  final Function onClick;
  final String title;
  final Stream<ProgressButtonStates> stream;
  final bool isEnabled;
  final Color backgroundColor;

  @override
  _ProgressButtonState createState() => _ProgressButtonState(stream: stream);
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {

  _ButtonStates _state = _ButtonStates.IDLE;
  double _width = double.infinity;
  double initialWidth = 0;
  GlobalKey _globalKey = GlobalKey();
  bool isEnabled;

  StreamSubscription statesSubscription;

  final Stream<ProgressButtonStates> stream;

  _ProgressButtonState({this.stream});

  @override
  void initState() {
    isEnabled = widget.isEnabled;
    super.initState();
    if (stream != null) {
      statesSubscription = stream.listen((newState) {
        switch(newState.runtimeType) {
          case ProgressState:
            startProgressAnimation();
            break;
          case ActionFailed:
            showOriginalState();
            break;
          case ActionSucceed:
            showSuccessState();
            break;
          case EnabledButtonState:
            setState(() {
              isEnabled = true;
            });
            break;
          case DisabledButtonState:
            setState(() {
              isEnabled = false;
            });
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    if (statesSubscription != null) {
      statesSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_width == double.infinity) {
      _width = MediaQuery.of(context).size.width - 32.fromDp();
    }

    return Center(
        child: Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
                key: _globalKey,
                    duration: Duration(milliseconds: 300),
                    width: _width,
                    height: 48.fromDp(),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)
                      ),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      color: widget.backgroundColor,
                      textColor: Colors.white,
                      onPressed: !isEnabled ? null : _onPressed,
                      child: setUpButtonChild(),
                    )
            ),
          ),
    );
  }

  void _onPressed() {
    if (_state != _ButtonStates.PROGRESS) {
      widget.onClick();
    }
  }

  setUpButtonChild() {
    if (_state == _ButtonStates.IDLE) {
      return Text(
        widget.title,
          style: TextStyle(
              fontSize: 16.fromSp(),
              fontWeight: FontWeight.w600
          )
      );
    } else if (_state == _ButtonStates.PROGRESS) {
      return Center(
        child: SizedBox(
          height: 24.fromDp(),
          width: 24.fromDp(),
          child: CircularProgressIndicator()
      ));
    } else {
      return Icon(Icons.check, color: Colors.white, size: 24.fromDp(),);
    }
  }

  void startProgressAnimation() {
    if (initialWidth == 0) {
      initialWidth = _globalKey.currentContext.size.width;
    }

    setState(() {
      _width = 48.fromDp();
      _state = _ButtonStates.PROGRESS;
    });
  }

  void showOriginalState() {
    setState(() {
      isEnabled = widget.isEnabled;
      _width = initialWidth;
      _state = _ButtonStates.IDLE;
    });
  }

  void showSuccessState() {
    setState(() {
      _state = _ButtonStates.COMPLETED;
    });
  }
}

enum _ButtonStates {IDLE, PROGRESS, COMPLETED}

abstract class ProgressButtonStates extends Equatable {
  @override
  List<Object> get props => [];
}
class ProgressState extends ProgressButtonStates {}
class ActionSucceed extends ProgressButtonStates {}
class EnabledButtonState extends ProgressButtonStates {}
class DisabledButtonState extends ProgressButtonStates {}
class ActionFailed extends ProgressButtonStates {

  final Exception exception;

  ActionFailed({this.exception});
}