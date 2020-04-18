import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../extensions/dp_converter/ui_extensions.dart';

class DarkLoadingProgress {
  final BuildContext _context;
  bool isProgressVisible = false;

  DarkLoadingProgress(this._context);

  void show() {
    if (isProgressVisible)
      return;
    else
      _ProgressView.showProgress(_context);
  }

  void dismiss() {
    _ProgressView.pendingDismiss = true;
    _ProgressView.dismiss();
  }
}

class _ProgressView {
  static final _ProgressView _singleton = _ProgressView._internal();

  static bool pendingDismiss = false;

  factory _ProgressView() {
    return _singleton;
  }

  _ProgressView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;

  static void showProgress(BuildContext context) {
    overlayState = Overlay.of(context);

    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = Colors.black;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 32.fromDp(),
              width: 32.fromDp(),
            ),
          ),
        );
      },
    );
    if (pendingDismiss) return;
    overlayState.insert(_overlayEntry);
  }

  static dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    pendingDismiss = false;
  }
}
