library animated_floatactionbuttons;

import 'package:flutter/material.dart';
import 'package:t7coach/shared/widgets/transform_float_button.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  final List<Widget> fabButtons;
  final Color colorStartAnimation;
  final Color colorEndAnimation;
  final AnimatedIconData animatedIconData;
  final String tooltip;

  _AnimatedFloatingActionButtonState state;

  AnimatedFloatingActionButton(
      {Key key, this.fabButtons, this.colorStartAnimation, this.colorEndAnimation, this.animatedIconData, this.tooltip})
      : super(key: key);

  @override
  _AnimatedFloatingActionButtonState createState() {
    state = _AnimatedFloatingActionButtonState();
    print('state: ' + state.toString());
    return state;
  }

  closeFloatingActionButton() {
    // state.close();
    print('TODO close');
  }
}

class _AnimatedFloatingActionButtonState extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.colorStartAnimation,
      end: widget.colorEndAnimation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  close() {
    if (isOpened) {
      animate();
    }
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: widget.tooltip,
        child: AnimatedIcon(
          icon: widget.animatedIconData,
          progress: _animateIcon,
        ),
      ),
    );
  }

  List<Widget> _setFabButtons() {
    List<Widget> processButtons = List<Widget>();
    for (int i = 0; i < widget.fabButtons.length; i++) {
      processButtons.add(TransformFloatButton(
        floatButton: widget.fabButtons[i],
        translateValue: _translateButton.value * (widget.fabButtons.length - i),
      ));
    }
    processButtons.add(toggle());
    return processButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: _setFabButtons(),
    );
  }
}