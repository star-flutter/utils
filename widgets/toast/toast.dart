import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../extensions/dp_converter/ui_extensions.dart';

enum ToastLength { SHORT, LONG }
enum ToastPosition { BOTTOM, CENTER, TOP }

const TOAST_SHORT = 1700;
const TOAST_LONG = 3700;

class Toast {

  static void show(String message, BuildContext context,
      {
        ToastLength duration = ToastLength.SHORT,
        ToastPosition gravity = ToastPosition.BOTTOM,
      }) {
    ToastView.createView(message, context, duration, gravity);
  }
}

class ToastView {
  static final ToastView _singleton = ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(String msg, BuildContext context, ToastLength duration, ToastPosition gravity) async {
    overlayState = Overlay.of(context);

    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = Colors.black;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return ToastWidget(
          message: msg,
          gravity: gravity,
          toastLength: duration,
        );
      },
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    Future.delayed(Duration(milliseconds: duration == ToastLength.SHORT ? TOAST_SHORT : TOAST_LONG)).then((value) {
      dismiss();
    });
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final ToastPosition gravity;
  final ToastLength toastLength;

  ToastWidget({
    Key key,
    @required this.message,
    @required this.gravity,
    @required this.toastLength
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ToastWidgetState(message: message,
        gravity: gravity,
        toastLength: toastLength
    );
  }
}

class ToastWidgetState extends State<ToastWidget> with TickerProviderStateMixin {

  final String message;
  final ToastPosition gravity;
  final ToastLength toastLength;

  double _opacity = 0;

  Animation<double> animation;
  AnimationController controller;

  ToastWidgetState({
    @required this.message,
    @required this.gravity,
    @required this.toastLength
  });

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          _opacity = controller.value;
        });
      });
    controller.forward();

    const int delayBetweenAnimations = 700; //300 for fade in, 300 for fade out, 100 just to be sure
    int delayMs = toastLength == ToastLength.SHORT ? TOAST_SHORT - delayBetweenAnimations : TOAST_LONG - delayBetweenAnimations;
    Future.delayed(Duration(milliseconds: delayMs)).then((result) {
      controller.reverse(from: 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: gravity == ToastPosition.TOP ? MediaQuery.of(context).viewInsets.top + 50.fromDp() : null,
        bottom: gravity == ToastPosition.BOTTOM ? MediaQuery.of(context).viewInsets.bottom + 50.fromDp() : null,
        child: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: _opacity,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20.fromDp()),
                    padding: EdgeInsets.fromLTRB(16.fromDp(), 10.fromDp(), 16.fromDp(), 10.fromDp()),
                    child: Text(message,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16.fromSp(),
                            color: Colors.white)
                    ),
                  )
              ),
            ),
          ),
        )
    );
  }
}