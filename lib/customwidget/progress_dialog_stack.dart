import 'package:flutter/material.dart';

class ProgressDialogStack extends StatelessWidget {
  final ProgressIndicator _indicator;
  final Widget _child;
  final double opacity;

  ProgressDialogStack(this._indicator, this._child, {this.opacity = 0.3});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _child,
      Opacity(
        opacity: this.opacity,
        child: ModalBarrier(
          color: Color(0xff6C6C6C),
        ),
      ),
      Center(
        child: _indicator,
      )
    ]);
  }
}
