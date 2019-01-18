import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kLinearProgressIndicatorHeight = 6.0;
const int _kIndeterminateLinearDuration = 1800;

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter(
      {this.backgroundColor,
      this.valueColor,
      this.value,
      this.animationValue,
      @required this.textDirection,
      @required this.radius})
      : assert(textDirection != null);

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final double animationValue;
  final TextDirection textDirection;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    RRect rect =
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    canvas.drawRRect(rect, paint);

    paint.color = valueColor;

    void drawBar(double x, double width) {
      if (width <= 0.0) return;

      double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
          break;
        case TextDirection.ltr:
          left = x;
          break;
      }
      RRect tempRRect = RRect.fromRectAndRadius(
          Offset(left, 0.0) & Size(width, size.height),
          Radius.circular(radius));
      canvas.drawRRect(tempRRect, paint);
    }

    if (value != null) {
      drawBar(0.0, value.clamp(0.0, 1.0) * size.width);
    }
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection;
  }
}

class RoundedLinearProgressIndicator extends ProgressIndicator {
  RoundedLinearProgressIndicator(
      {Key key,
      double value,
      Color backgroundColor,
      Animation<Color> valueColor,
      String semanticsLabel,
      String semanticsValue,
      @required this.radius,
      this.height,
      this.width})
      : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  final double radius;
  final double width;
  final double height;

  Color _getBackgroundColor(BuildContext context) =>
      backgroundColor ?? Theme.of(context).backgroundColor;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? Theme.of(context).accentColor;

  Widget _buildSemanticsWrapper({
    @required BuildContext context,
    @required Widget child,
  }) {
    String expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }

  @override
  _RoundedLinearProgressIndicatorState createState() =>
      _RoundedLinearProgressIndicatorState();
}

class _RoundedLinearProgressIndicatorState
    extends State<RoundedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  Widget _buildIndicator(BuildContext context,
      TextDirection textDirection) {
    if (widget.width != null && widget.height != null) {
      return widget._buildSemanticsWrapper(
        context: context,
        child: Container(
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
            painter: _LinearProgressIndicatorPainter(
                backgroundColor: widget._getBackgroundColor(context),
                valueColor: widget._getValueColor(context),
                value: widget.value,
                // ignored if widget.value is not null
                textDirection: textDirection,
                radius: widget.radius),
          ),
        ),
      );
    }
    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: _kLinearProgressIndicatorHeight,
        ),
        child: CustomPaint(
          painter: _LinearProgressIndicatorPainter(
              backgroundColor: widget._getBackgroundColor(context),
              valueColor: widget._getValueColor(context),
              value: widget.value,
              // ignored if widget.value is not null
              textDirection: textDirection,
              radius: widget.radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    return _buildIndicator(context, textDirection);
  }
}
